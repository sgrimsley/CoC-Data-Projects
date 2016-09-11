#
# Server file for City of Chicago Average Employee Salary Application (SG)
#

library(shiny)
library(dplyr)

# Read in data file
data1 <- read.csv("CoCData_20160822.csv",stringsAsFactors = FALSE)

# Define server logic
shinyServer(function(input, output) {

  deptmax <- length(unique(data1$department))
  jobmax <- length(unique(data1$job_titles))
  
  # UI Functions
  
  # Department slider UI
  output$choose_deptrange <- renderUI({
    sliderInput("deptcount", "Dept Ranks to Return",
                min = 1,
                max = deptmax,
                value = c(1,10))
  })
  
  
  # Job Title slider UI
  output$choose_jobrange <- renderUI({
    sliderInput("jobcount", "Job Ranks to Return",
                min = 1,
                max = jobmax,
                value = c(1,10))
  })

  # Create alphabatized list of depts / jobs for selection box UIs (choices)
  depts <- unique(data1$department)
  depts <- depts[order(depts)]
  jobs <- unique(data1$job_titles)
  jobs <- jobs[order(jobs)]

  
  # Department selection box UI
  output$choose_department <- renderUI({
  selectInput("dept", "Departments",
                     choices = depts,
                     multiple=TRUE,
                     selectize=TRUE)
  })
  
  
  # Job Title selection box UI
  output$choose_jobs <- renderUI({
    selectInput("job", "Job Titles",
                choices = jobs,
                multiple=TRUE,
                selectize=TRUE)
  })
  
  
# Render functions
  
  # Department mean table
  output$deptmean <- renderTable({

    # Filter data, based on UI filter choice
    meanout <- switch(input$choose_filter,
               Department = { data1 %>%  filter(department %in% input$dept) },
               JobTitle = {data1 %>%  filter(job_titles %in% input$job) }
    )
    
    # Calculate mean of filtered data
    meanout <- meanout %>%  group_by(department) %>% 
      summarise(dptmean=mean(employee_annual_salary, na.rm=TRUE)) %>% 
      arrange(desc(dptmean))

    # Add column for ranking, format numbers    
    meanout <- meanout %>%
      mutate(rank=as.integer(rownames(meanout)),
             dptmean = format(dptmean, big.mark=",", justify="right")) %>%
      select(rank,department,dptmean)
    
    # Output table, based on filter choice and slider
    meanout <- switch(input$choose_filter,
              Department = { meanout},
              JobTitle = { meanout[input$deptcount[1]:input$deptcount[2],] }
            )
   }, include.rownames=FALSE) # Remove row numbers from table output
  
   # Job Title mean table
   output$jobmean <- renderTable({

   # Filter data, based on UI filter choice
   meanout2 <- switch(input$choose_filter,
          Department = { data1 %>%  filter(department %in% input$dept) },
          JobTitle = {data1 %>%  filter(job_titles %in% input$job) }
          )
   
   # Calculate mean of filtered data
   meanout2 <-meanout2 %>% group_by(job_titles) %>% 
        summarise(jobmean=mean(employee_annual_salary, na.rm=TRUE)) %>% 
        arrange(desc(jobmean))      
  
   # Add column for ranking, format numbers        
   meanout2 <- meanout2 %>%
      mutate(rank=as.integer(rownames(meanout2)), 
             jobmean = format(jobmean, big.mark=",", justify="right")) %>%
      select(rank, job_titles, jobmean)

   # Output table, based on filter choice and slider
   meanout2 <- switch(input$choose_filter,
              Department = {meanout2[input$jobcount[1]:input$jobcount[2],] },
              JobTitle = { meanout2}
          )
   }, include.rownames=FALSE) # Remove row numbers from table output

})
