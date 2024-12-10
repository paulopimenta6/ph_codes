library(readODS)
library(zoo)
library(ggplot2)

tw_usa <- read_ods("TAIWAN_USA.ods")
tw_jp <- read_ods("TAIWAN_JAPAN.ods")
tw_hkcn <- read_ods("TAIWAN_HKCHINA.ods")
tw_asean <- read_ods("TAIWAN_ASEAN.ods")
tw_europe <- read_ods("TAIWAN_EUROPE.ods")
tw_others <- read_ods("TAIWAN_OUTROS.ods")

time <- seq(as.Date("2022-01-01"), as.Date("2023-06-30"), by = "month")

###Taiwan-JP
tw_jp_ele_total <- tw_jp$Electronic.Products[1]
tw_jp_ele <- tw_jp$Electronic.Products[-1]
ts_tw_jp_ele <- zoo(tw_jp_ele, time)
plot(ts_tw_jp_ele, xlab = "2022-01-01 até 2023-06-30", 
     ylab = "Exportações Taiwan - Japão - USD (milhões de US$)")

###Taiwan-Hong Kong e China Continental
tw_hkcn_ele_total <- tw_hkcn$Electronic.Products[1]
tw_hkcn_ele <- tw_hkcn$Electronic.Products[-1]
ts_tw_hkcn_ele <- zoo(tw_hkcn_ele, time)
plot(ts_tw_hkcn_ele, xlab = "2022-01-01 até 2023-06-30", 
     ylab = "Exportações Taiwan - HK e China Continental - USD (milhões de US$)")

###Taiwan-ASEAN
tw_asean_ele_total <- tw_asean$Electronic.Products[1]
tw_asean_ele <- tw_asean$Electronic.Products[-1]
ts_tw_asean_ele <- zoo(tw_asean_ele, time)
plot(ts_tw_asean_ele, xlab = "2022-01-01 até 2023-06-30", 
     ylab = "Exportações Taiwan - ASEAN - USD (milhões de US$)")


###Taiwan-USA
tw_usa_ele_total <- tw_usa$Electronic.Products[1]
tw_usa_ele <- tw_usa$Electronic.Products[-1]
ts_tw_usa_ele <- zoo(tw_usa_ele, time)
plot(ts_tw_usa_ele, xlab = "2022-01-01 até 2023-06-30", 
     ylab = "Exportações Taiwan - EUA - USD (milhões de US$)")

###Taiwan-Europe
tw_europe_ele_total <- tw_europe$Electronic.Products[1]
tw_europe_ele <- tw_europe$Electronic.Products[-1]
ts_tw_europe_ele <- zoo(tw_europe_ele, time)
plot(ts_tw_europe_ele, xlab = "2022-01-01 até 2023-06-30", 
     ylab = "Exportações Taiwan - Europa - USD (milhões de US$)")

###Taiwan-Outros
tw_others_ele_total <- tw_others$Electronic.Products[1]
tw_others_ele <- tw_others$Electronic.Products[-1]
ts_tw_others_ele <- zoo(tw_others_ele, time)
plot(ts_tw_others_ele, xlab = "2022-01-01 até 2023-06-30", 
     ylab = "Exportações Taiwan - Resto do mundo - USD (milhões de US$)")

totais_tw_exp_ele <- c(tw_jp_ele_total, tw_hkcn_ele_total, tw_asean_ele_total,
                       tw_usa_ele_total, tw_europe_ele_total,
                                   tw_others_ele_total)
paises <- c("Japão", "HK e CN", "ASEAN", "EUA", "Europa", "Resto do Mundo")
df_totais_maximos_exp_tw <- data.frame(paises, totais_tw_exp_ele)

###-----------------------------------------------------------------------------
###Usando ggplot2 para gráficos de barra
ggplot(df_totais_maximos_exp_tw, aes(x=paises, 
                 y=totais_tw_exp_ele)) + 
                 xlab("Paises") + ylab("USD (milhões de US$)") +
                 geom_bar(stat = "identity")
###Japão
tw_jp_ele_ggplot <- data.frame(time, tw_jp_ele)
tw_jp_ele_ggplot_plot <- ggplot(tw_jp_ele_ggplot, aes(x=time, y=tw_jp_ele)) +
  geom_line() + 
  xlab("2022-01-01 até 2023-06-30") +
  ylab("Exportações Taiwan - Japão - USD (milhões de US$)")
tw_jp_ele_ggplot_plot

###Hong Kong e China Continental
tw_hkcn_ele_ggplot <- data.frame(time, tw_hkcn_ele)
tw_hkcn_ele_ggplot_plot <- ggplot(tw_hkcn_ele_ggplot, aes(x=time, y=tw_hkcn_ele)) +
  geom_line() + 
  xlab("2022-01-01 até 2023-06-30") +
  ylab("Exportações Taiwan - HK e CN Cont - USD (milhões de US$)")
tw_hkcn_ele_ggplot_plot

###ASEAN
tw_asean_ele_ggplot <- data.frame(time, tw_asean_ele)
tw_asean_ele_ggplot_plot <- ggplot(tw_asean_ele_ggplot, aes(x=time, y=tw_asean_ele)) +
  geom_line() + 
  xlab("2022-01-01 até 2023-06-30") +
  ylab("Exportações Taiwan - ASEAN - USD (milhões de US$)")
tw_asean_ele_ggplot_plot

###USA 
tw_usa_ele_ggplot <- data.frame(time, tw_usa_ele)
tw_usa_ele_ggplot_plot <- ggplot(tw_usa_ele_ggplot, aes(x=time, y=tw_usa_ele)) +
  geom_line() + 
  xlab("2022-01-01 até 2023-06-30") +
  ylab("Exportações Taiwan - EUA - USD (milhões de US$)")
tw_usa_ele_ggplot_plot

###Europa 
tw_europe_ele_ggplot <- data.frame(time, tw_europe_ele)
tw_europe_ele_ggplot_plot <- ggplot(tw_europe_ele_ggplot, aes(x=time, y=tw_europe_ele)) +
  geom_line() + 
  xlab("2022-01-01 até 2023-06-30") +
  ylab("Exportações Taiwan - Europa - USD (milhões de US$)")
tw_europe_ele_ggplot_plot

###Resto do mundo
tw_others_ele_ggplot <- data.frame(time, tw_others_ele)
tw_others_ele_ggplot_plot <- ggplot(tw_others_ele_ggplot, aes(x=time, y=tw_others_ele)) +
  geom_line() + 
  xlab("2022-01-01 até 2023-06-30") +
  ylab("Exportações Taiwan - Resto do mundo - USD (milhões de US$)")
tw_others_ele_ggplot_plot
###-----------------------------------------------------------------------------