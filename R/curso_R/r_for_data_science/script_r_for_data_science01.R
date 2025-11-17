################################################################################
if(!require("pacman")){
  install.packages("nycflights13", "gapminder", "Lahman", "tidyverse")
}
pacman::p_load(nycflights13, gapminder, Lahman, tidyverse)
################################################################################
# Criando visualizacoes
ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = cyl, y = hwy))

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = class))

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), colour = "blue")

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap( ~class, nrow = 2)

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid( drv ~ cyl)

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid( . ~ cyl)

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid( . ~ cty)

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid( year ~ cty)

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(drv ~ class, nrow = 2)

ggplot2::ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
################################################################################
ggplot2::ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot2::ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot2::ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, colour = drv),
  show.legend = TRUE
  )
################################################################################
ggplot2::ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(x = displ, y = hwy))
################################################################################
ggplot2::ggplot(data = mpg, mapping = aes(displ, y = hwy)) + 
  geom_point(mapping = aes(colour = class)) +
  geom_smooth()
################################################################################