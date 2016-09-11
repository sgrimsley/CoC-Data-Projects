#
# User interface file for City of Chicago Average Employee Salary Application (SG)
#

library(shiny)

# Define UI
shinyUI(fluidPage(
  
  # Application title
  titlePanel("City of Chicago Average Employee Salaries by Job or Department"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      # User input for filer choice (department or job title)
      radioButtons("choose_filter", "Choose filter method:",
                   choices = c("Department", "JobTitle"),
                   selected = "Department"
                   ),
      
      # Conditional panel for department selection
      conditionalPanel(
        condition = "input.choose_filter == 'Department'",
        uiOutput("choose_department")
        ),
      
      # Conditional panel for job title selection
      conditionalPanel(
        condition = "input.choose_filter == 'JobTitle'",
        uiOutput("choose_jobs")
        ),
      
      # Conditional panel for department if filtering by job title 
      conditionalPanel(
        condition = "input.choose_filter == 'JobTitle'",
        uiOutput("choose_deptrange")
      ),
      
      # Conditional panel for job title if filtering by department
      conditionalPanel(
        condition = "input.choose_filter == 'Department'",
        uiOutput("choose_jobrange")
      ),
      
      ## Documentation
      
      h5("This application dynamically calculates the average salary for City of Chicago employees 
         by Department(s) and Job Title(s).  This allows comparison of average salaries for a job title between departments, 
         and comparison between job titles within a department."),
      h5("Choose a filter method (Department or JobTitle), then select one or multiple options from the selection box. 
        Typing a partial string (ie. account) limits choices and is useful for finding positions of a similar type."),
      h5("Filtering by department will show the average salary for the department for all job titles, and the average 
         for each job title within the department.  Filtering by JobTitle will show the average salary for that job title and for that job title within each department.  
        "),
      h5("Table results are returned in descending order of the average employee salary.  Use the slider to expand table results
         or to focus on specific ranges.  Slider maxes reflect the total unique entries in the data set."),
      h5("Data is from the City of Chicago data portal, as of 8/22/2016.")
      ),
    
    # Produce table output, based on user selections
    mainPanel(
       h3("Department Average"),
       tableOutput("deptmean"),
       h3("Job Average"),
       tableOutput("jobmean")
      
    )
  )
))
