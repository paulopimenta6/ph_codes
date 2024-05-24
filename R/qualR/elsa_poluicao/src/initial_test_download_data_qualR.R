  library(qualR)
  
  cetesb_aqs # To check Pinheiros aqs_code
  cetesb_param # To check Ozone pol_code
  
  my_user_name <- "paulo.pimenta@alumni.usp.br"
  my_password <- "Superph0101!"
  pin_code <- 99
  start_date <- "01/01/2020"
  end_date <- "07/01/2020"
  
  pin_o3 <- cetesb_retrieve_param(my_user_name,
                                  my_password,
                                  "16",
                                  pin_code, # It could also be "Pinheiros"
                                  start_date,
                                  end_date,
                                  to_csv = TRUE)
