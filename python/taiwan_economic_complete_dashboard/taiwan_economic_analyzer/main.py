"""
Taiwan Economic Analyzer - Orquestrador Principal
Suporta execucao unica ou continua (daemon de producao)
"""
import os
import sys
import time
import logging
import argparse
import signal
import threading
from datetime import datetime
from typing import Optional

import pandas as pd

from config import CONFIG
from scraper import TaiwanDataScraper
from processor import DataProcessor
from analyzer import StatisticalAnalyzer
from database import DatabaseManager
from dashboard_png import DashboardBuilder

# Configuracao de logging
logging.basicConfig(
    level=logging.INFO,
    format=CONFIG.LOG_FORMAT,
    datefmt='%Y-%m-%d %H:%M:%S',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler(os.path.join(CONFIG.LOGS_DIR, 'taiwan_analyzer.log'))
    ]
)
logger = logging.getLogger("TaiwanMain")


class ProductionDaemon:
    """
    Daemon de producao para operacao continua.
    Gerencia ciclo de vida, health checks, alertas e recuperacao.
    """

    def __init__(self, analyzer):
        self.analyzer = analyzer
        self.running = False
        self.shutdown_event = threading.Event()
        self.health_status = {'last_success': None, 'failures': 0, 'total_runs': 0}
        self.alert_threshold = 3  # Falhas consecutivas antes de alerta

    def start(self):
        """Inicia o daemon de producao"""
        logger.info("=" * 70)
        logger.info("INICIANDO DAEMON DE PRODUCAO")
        logger.info("=" * 70)
        logger.info(f"Intervalo: {self.analyzer.config.SCHEDULE_INTERVAL_MINUTES} minutos")
        logger.info(f"Banco: {self.analyzer.config.DB_PATH}")
        logger.info(f"Dashboard: {self.analyzer.config.DASHBOARD_PNG_PATH}")
        logger.info("Comandos: Ctrl+C para parar | SIGUSR1 para forcar execucao")
        logger.info("=" * 70)

        self.running = True
        self._setup_signal_handlers()

        # Execucao inicial
        self._execute_cycle()

        # Loop principal
        while self.running and not self.shutdown_event.is_set():
            try:
                # Aguardar com possibilidade de interrupcao
                self.shutdown_event.wait(timeout=self.analyzer.config.SCHEDULE_INTERVAL_MINUTES * 60)

                if not self.running:
                    break

                self._execute_cycle()

            except Exception as e:
                logger.error(f"Erro no ciclo do daemon: {e}")
                self.health_status['failures'] += 1

                # Verificar se precisa de alerta
                if self.health_status['failures'] >= self.alert_threshold:
                    self._send_alert(f"{self.health_status['failures']} falhas consecutivas")

                # Aguardar antes de tentar novamente
                time.sleep(300)  # 5 minutos de cooldown

        logger.info("Daemon encerrado")

    def _execute_cycle(self):
        """Executa um ciclo completo do pipeline"""
        logger.info(f"\n{'='*70}")
        logger.info(f"CICLO #{self.health_status['total_runs'] + 1} - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        logger.info(f"{'='*70}")

        success = self.analyzer.run_pipeline('full')

        if success:
            self.health_status['last_success'] = datetime.now()
            self.health_status['failures'] = 0
            self.health_status['total_runs'] += 1
            logger.info(f"Ciclo concluido com sucesso. Total: {self.health_status['total_runs']}")
        else:
            self.health_status['failures'] += 1
            logger.warning(f"Ciclo falhou. Falhas consecutivas: {self.health_status['failures']}")

    def _setup_signal_handlers(self):
        """Configura handlers de sinais"""
        def handle_sigterm(signum, frame):
            logger.info("SIGTERM recebido. Encerrando graciosamente...")
            self.stop()

        def handle_sigusr1(signum, frame):
            logger.info("SIGUSR1 recebido. Forcando execucao...")
            threading.Thread(target=self._execute_cycle).start()

        def handle_sighup(signum, frame):
            logger.info("SIGHUP recebido. Recarregando configuracao...")
            # Recarregar config se necessario

        signal.signal(signal.SIGTERM, handle_sigterm)
        signal.signal(signal.SIGINT, handle_sigterm)

        # SIGUSR1 apenas em sistemas Unix
        if hasattr(signal, 'SIGUSR1'):
            signal.signal(signal.SIGUSR1, handle_sigusr1)
        if hasattr(signal, 'SIGHUP'):
            signal.signal(signal.SIGHUP, handle_sighup)

    def _send_alert(self, message: str):
        """Envia alerta de producao"""
        logger.critical(f"ALERTA DE PRODUCAO: {message}")
        try:
            db = DatabaseManager(self.analyzer.config.DB_PATH)
            db.connect()
            db.create_alert('production', 'CRITICAL', message)
            db.close()
        except Exception as e:
            logger.error(f"Falha ao enviar alerta: {e}")

    def stop(self):
        """Para o daemon graciosamente"""
        logger.info("Solicitando parada do daemon...")
        self.running = False
        self.shutdown_event.set()


class TaiwanEconomicAnalyzer:
    """Orquestrador principal do sistema."""

    def __init__(self, config=CONFIG):
        self.config = config
        self.scraper = TaiwanDataScraper(config)
        self.processor = DataProcessor(config)
        self.analyzer = StatisticalAnalyzer()
        self.dashboard = DashboardBuilder()
        self.db = DatabaseManager(config.DB_PATH)
        self.df_raw = None
        self.df_clean = None
        self.analysis_results = None
        self.execution_count = 0

    def run_pipeline(self, mode: str = 'full') -> bool:
        """Executa o pipeline completo."""
        start_time = time.time()
        self.execution_count += 1

        logger.info("=" * 70)
        logger.info(f"EXECUCAO #{self.execution_count} - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        logger.info("=" * 70)

        try:
            # 1. COLETA
            if mode in ('full', 'scrape'):
                logger.info("\n[ETAPA 1/5] COLETA DE DADOS")
                scrape_result = self.scraper.collect(prefer_real=True)
                self.df_raw = scrape_result.df

                if self.df_raw is None or len(self.df_raw) == 0:
                    raise ValueError("Falha na coleta de dados!")

                logger.info(f"Dados coletados: {len(self.df_raw)} registros (fonte: {scrape_result.source})")

            # 2. PROCESSAMENTO
            if mode in ('full', 'process') and self.df_raw is not None:
                logger.info("\n[ETAPA 2/5] PROCESSAMENTO")
                self.df_clean = self.processor.process(self.df_raw)
                logger.info(f"Dados processados: {len(self.df_clean)} registros, {len(self.df_clean.columns)} colunas")

            # 3. ANALISE ESTATISTICA
            if mode in ('full', 'analyze') and self.df_clean is not None:
                logger.info("\n[ETAPA 3/5] ANALISE ESTATISTICA")
                self.analysis_results = self.analyzer.analyze(self.df_clean)

                # Gerar relatorio
                report = self.analyzer.generate_analysis_report(self.df_clean)
                report_path = os.path.join(self.config.LOGS_DIR, f'analysis_report_{datetime.now().strftime("%Y%m%d_%H%M%S")}.txt')
                with open(report_path, 'w') as f:
                    f.write(report)
                logger.info(f"Relatorio salvo: {report_path}")

            # 4. BANCO DE DADOS
            if mode in ('full',) and self.df_clean is not None:
                logger.info("\n[ETAPA 4/5] BANCO DE DADOS")
                with self.db:
                    self.db.insert_economic_data(self.df_clean)
                    self.db.insert_monthly_stats(self.df_clean)

                    # Inserir dados MOEA se disponiveis
                    moea_cols = ['total_exports', 'total_imports', 'trade_balance',
                                'electronic_exports', 'machinery_exports', 'chemicals_exports',
                                'textiles_exports', 'steel_exports', 'plastic_exports',
                                'mineral_exports', 'info_tech_exports', 'optoelectronic_exports',
                                'semiconductor_exports']
                    if any(col in self.df_clean.columns for col in moea_cols):
                        self.db.insert_moea_data(self.df_clean)

                    # Parceiros comerciais
                    partners = [
                        ('China', 'Export', 2025, 85000, 28.5),
                        ('USA', 'Export', 2025, 45000, 15.1),
                        ('ASEAN', 'Export', 2025, 54000, 18.1),
                        ('Japan', 'Export', 2025, 36000, 12.1),
                        ('South Korea', 'Export', 2025, 24000, 8.1),
                        ('EU', 'Export', 2025, 36000, 12.1),
                        ('Others', 'Export', 2025, 18000, 6.0),
                        ('China', 'Import', 2025, 65000, 22.3),
                        ('USA', 'Import', 2025, 38000, 13.0),
                        ('Japan', 'Import', 2025, 42000, 14.4),
                        ('ASEAN', 'Import', 2025, 48000, 16.5),
                        ('South Korea', 'Import', 2025, 29000, 9.9),
                        ('EU', 'Import', 2025, 35000, 12.0),
                        ('Others', 'Import', 2025, 34000, 11.9),
                    ]
                    self.db.insert_partners(partners)

                    if self.analysis_results:
                        self.db.insert_analysis(self.analysis_results)

                    source = ','.join(self.scraper.data_sources_used) if self.scraper.data_sources_used else 'unknown'
                    duration = time.time() - start_time
                    self.db.log_execution(source, len(self.df_clean), 'SUCCESS', '', duration)

                    summary = self.db.get_summary()
                    logger.info(f"Resumo DB: {summary}")

            # 5. DASHBOARD PNG
            if mode in ('full', 'dashboard') and self.df_clean is not None:
                logger.info("\n[ETAPA 5/5] DASHBOARD PNG")
                self.dashboard.build(self.df_clean, self.analysis_results)

            elapsed = time.time() - start_time
            logger.info("\n" + "=" * 70)
            logger.info(f"PIPELINE CONCLUIDO EM {elapsed:.2f}s")
            logger.info("=" * 70)
            logger.info(f"DB: {self.config.DB_PATH}")
            logger.info(f"Dashboard PNG: {self.config.DASHBOARD_PNG_PATH}")
            logger.info(f"Dashboard Streamlit: streamlit run app.py")

            return True

        except Exception as e:
            elapsed = time.time() - start_time
            logger.critical(f"ERRO FATAL: {e}", exc_info=True)

            try:
                with self.db:
                    self.db.log_execution('error', 0, 'FAILED', str(e), elapsed)
            except:
                pass

            return False

    def run_continuous(self):
        """Executa em modo daemon de producao continua."""
        daemon = ProductionDaemon(self)
        daemon.start()


def main():
    """Funcao principal com argumentos de linha de comando"""
    parser = argparse.ArgumentParser(
        description='Taiwan Economic Analyzer v2.1 - Sistema de Producao',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Modos de execucao:
  full       - Pipeline completo (padrao)
  scrape     - Apenas coleta
  process    - Apenas processamento
  analyze    - Apenas analise
  dashboard  - Apenas dashboard
  continuous - Modo daemon de producao continua

Exemplos:
  # Execucao unica
  python main.py --mode full

  # Modo producao (daemon)
  python main.py --mode continuous --interval 60

  # Forcar execucao em daemon rodando
  kill -USR1 <PID>

  # Parar daemon graciosamente
  kill -TERM <PID>

Configuracoes de producao:
  --interval INTERVAL     Intervalo entre execucoes (minutos)
  --alert-threshold N     Falhas consecutivas antes de alerta
  --db PATH              Caminho do banco de dados
  --start-year YEAR      Ano inicial
  --end-year YEAR        Ano final
        """
    )

    parser.add_argument('--mode', choices=['full', 'scrape', 'process', 'analyze', 
                                           'dashboard', 'continuous'],
                       default='full', help='Modo de execucao')
    parser.add_argument('--db', default=CONFIG.DB_PATH, help='Caminho do banco de dados')
    parser.add_argument('--dashboard', default=CONFIG.DASHBOARD_PNG_PATH, 
                       help='Caminho do dashboard PNG')
    parser.add_argument('--start-year', type=int, default=CONFIG.START_YEAR,
                       help='Ano inicial')
    parser.add_argument('--end-year', type=int, default=CONFIG.END_YEAR,
                       help='Ano final')
    parser.add_argument('--interval', type=int, default=CONFIG.SCHEDULE_INTERVAL_MINUTES,
                       help='Intervalo em minutos (modo continuo)')
    parser.add_argument('--alert-threshold', type=int, default=3,
                       help='Falhas consecutivas antes de alerta')
    parser.add_argument('--no-real', action='store_true',
                       help='Usar apenas dados simulados')

    args = parser.parse_args()

    # Atualizar configuracao
    config = CONFIG
    config.DB_PATH = args.db
    config.DASHBOARD_PNG_PATH = args.dashboard
    config.START_YEAR = args.start_year
    config.END_YEAR = args.end_year
    config.SCHEDULE_INTERVAL_MINUTES = args.interval

    # Criar instancia
    app = TaiwanEconomicAnalyzer(config)

    # Executar
    if args.mode == 'continuous':
        app.run_continuous()
    else:
        app.run_pipeline(args.mode)


if __name__ == '__main__':
    main()
