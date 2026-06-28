"""
Modulo de Atualizacao Automatica do Dashboard
Garante que o dashboard Streamlit seja atualizado em tempo real
quando novos dados sao coletados pelo daemon.
"""
import os
import time
import logging
import threading
from datetime import datetime
from typing import Optional

import streamlit as st

from config import CONFIG
from database import DatabaseManager

logger = logging.getLogger("TaiwanAutoUpdate")


class DashboardAutoUpdater:
    """
    Gerencia atualizacao automatica do dashboard Streamlit.
    Verifica mudancas no banco de dados e recarrega dados quando necessario.
    """

    def __init__(self, check_interval: int = 30):
        self.check_interval = check_interval  # segundos
        self.last_db_mtime = 0
        self.last_record_count = 0
        self.update_count = 0

    def check_for_updates(self) -> bool:
        """
        Verifica se o banco de dados foi atualizado desde a ultima verificacao.
        Retorna True se houver atualizacao.
        """
        if not os.path.exists(CONFIG.DB_PATH):
            return False

        current_mtime = os.path.getmtime(CONFIG.DB_PATH)

        # Verificar se houve mudanca no arquivo
        if current_mtime > self.last_db_mtime:
            self.last_db_mtime = current_mtime

            # Verificar se aumentou o numero de registros
            try:
                db = DatabaseManager()
                db.connect()
                summary = db.get_summary()
                db.close()

                current_count = summary.get('economic_data', 0)
                if current_count != self.last_record_count:
                    self.last_record_count = current_count
                    self.update_count += 1
                    logger.info(f"Atualizacao detectada! Registros: {current_count} (atualizacao #{self.update_count})")
                    return True
            except Exception as e:
                logger.error(f"Erro ao verificar atualizacao: {e}")

        return False

    def get_last_update_info(self) -> dict:
        """Retorna informacoes sobre a ultima atualizacao"""
        if os.path.exists(CONFIG.DB_PATH):
            mtime = os.path.getmtime(CONFIG.DB_PATH)
            return {
                'last_update': datetime.fromtimestamp(mtime).strftime('%Y-%m-%d %H:%M:%S'),
                'seconds_ago': int(time.time() - mtime),
                'update_count': self.update_count,
                'db_size_mb': round(os.path.getsize(CONFIG.DB_PATH) / (1024 * 1024), 2)
            }
        return {'last_update': 'Nunca', 'seconds_ago': None, 'update_count': 0, 'db_size_mb': 0}


# Funcao para Streamlit - verificacao em tempo real
def render_auto_update_status():
    """Renderiza status de atualizacao automatica no Streamlit"""
    updater = DashboardAutoUpdater()
    info = updater.get_last_update_info()

    st.sidebar.markdown("---")
    st.sidebar.subheader("🔄 Atualizacao Automatica")

    col1, col2 = st.sidebar.columns(2)
    with col1:
        st.metric("Atualizacoes", info['update_count'])
    with col2:
        st.metric("Tamanho DB", f"{info['db_size_mb']} MB")

    if info['seconds_ago'] is not None:
        minutes_ago = info['seconds_ago'] // 60
        if minutes_ago < 1:
            st.sidebar.success(f"✅ Atualizado agora")
        elif minutes_ago < 60:
            st.sidebar.info(f"⏱️ {minutes_ago} min atras")
        else:
            hours_ago = minutes_ago // 60
            st.sidebar.warning(f"⚠️ {hours_ago}h atras")

    st.sidebar.caption(f"Ultimo: {info['last_update']}")

    # Botao de refresh manual
    if st.sidebar.button("🔄 Forcar Atualizacao"):
        st.rerun()


def auto_refresh_component(interval_seconds: int = 60):
    """
    Componente de auto-refresh para Streamlit.
    Usa st.rerun() para recarregar a pagina quando detecta atualizacao.
    """
    updater = DashboardAutoUpdater(check_interval=interval_seconds)

    # Verificar atualizacao
    if updater.check_for_updates():
        st.toast("🔄 Novos dados detectados! Atualizando dashboard...", icon="📊")
        time.sleep(1)  # Pequena pausa para o toast aparecer
        st.rerun()

    # Configurar auto-refresh via HTML meta tag (fallback)
    st.markdown(f"""
        <meta http-equiv="refresh" content="{interval_seconds}">
    """, unsafe_allow_html=True)
