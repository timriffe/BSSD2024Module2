
library(tidyverse)
meta <- fwf_widths(widths = c(3,3,8),
              col_names = c("standard","age","pop"))
seer <-
  read_fwf("https://seer.cancer.gov/stdpopulations/stdpop.19ages.txt", col_positions = meta,
           col_types = "cdd") |> 
  group_by(standard) |> 
  mutate(structure = pop / sum(pop))

# 012 = World (WHO 2000-2025) Std Million (single ages to 99)
# 205 = 2000 U.S. Std Population (single ages to 99 - Census P25-1130)
seer |> 
  mutate(n = case_when(age == 0 ~ 1,
                       age == 1 ~ 4,
                       TRUE ~ 5),
         structure = structure / n) |> 
  filter(standard == "010") |> 
  ggplot(aes(x=age,y=structure, color = standard)) +
  geom_line()

