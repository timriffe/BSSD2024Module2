# a simple lifetable function 
# (too simplified for actual production use)
# but it's good enough for anything we're doing.

LT_tidy <- function(data, radix = 1){
  out <-
    data |> 
    mutate(
      mx = if_else(is.na(mx),.5,mx),
      n = rep(1, n()),
      ax = case_when(
        age == 0 & mx < .02012 ~ .14916 - 2.02536 * mx,
        age == 0 & mx < .07599 ~ 0.037495 + 3.57055 * mx,
        age == 0 & mx >= .07599 ~ 0.30663,
        age == 110 ~ 1 / mx,
        TRUE ~ n / 2),
      ax = if_else(is.infinite(ax),n/2,ax),  # hack
      qx = if_else(age == 110, 1,
                   (mx * n) / (1 + (n - ax) * mx)),
      qx = if_else(qx > 1, 1, qx),
      px = 1 - qx,
      lx = radix * c(1, cumprod(px[-n()])),
      dx = qx * lx,
      Lx = n * lx - (n - ax) * dx,
      Tx = Lx %>% rev() %>% cumsum() %>% rev(),
      ex = Tx / lx,
      ex = ifelse(is.nan(ex),ax,ex)) 
  return(out)
}
