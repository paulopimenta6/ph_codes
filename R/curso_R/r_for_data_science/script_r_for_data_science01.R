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
ggplot2::ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(colour = class)) +
  geom_smooth(
    data = filter(mpg, class == "subcompact"),
    mapping = aes(colour = class),
    se = FALSE
  ) +
  geom_smooth(
    data = filter(mpg, class == "compact"),
    mapping = aes(colour = class),
    se = FALSE
  )
################################################################################
ggplot2::ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

ggplot2::ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))

demo <- tribble(
  ~a, ~b,
  "ba1", 20,
  "bar2", 30,
  "bar3", 40
)

ggplot2::ggplot(data = demo) +
  geom_bar(mapping = aes(x = a, y = b), stat = "identity")

ggplot2::ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

ggplot2::ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
    )
################################################################################
ggplot2::ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, colour = cut))

ggplot2::ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, colour = cut, fill = cut))

ggplot2::ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))