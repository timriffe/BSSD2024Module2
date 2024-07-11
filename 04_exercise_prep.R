
library(HMDHFDplus)
getHFDcountries() |> View()
asfr <-readHFDweb("FRATNP","asfrRR", 
                  username = Sys.getenv("us"), 
                  password = Sys.getenv("pw"))
asfr |> 
  clean_names() |> 
  select(-open_interval) |> 
  filter(year == 2015) |> 
  write_csv("data/FR_asfr_2015.csv")

LT <- readHMDweb("FRATNP","fltper_1x1",
                 username = Sys.getenv("us"), 
                 password = Sys.getenv("pw"))
LT |> 
  rename(year = Year, age = Age) |> 
  filter(year == 2015) |> 
  select(-OpenInterval) |> 
  write_csv("data/FR_fLT_2015.csv")

Pop <- readHMDweb("FRATNP","Population",
                 username = Sys.getenv("us"), 
                 password = Sys.getenv("pw"))
Pop |> 
  clean_names() |> 
  filter(year == 2015) |> 
  select(year, age, males = male1, females = female1, total = total1) |> 
  write_csv("data/FR_P_2015.csv")
