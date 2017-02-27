SUDESA_report <-
  function(report = 1,
           start_date = '2016-12-01',
           end_date = Sys.Date()) {
    #Objective: This function generates three different reports. This function is going
    #to connect automatically to local server of CERMEL to have access to update SUDESA
    #data saved on OpenHDS server and PostGIS.
    
    ###################################################################################
    #1- Rapport recapitulatif du nombres ménages enrollés par les enqueteurs          #
    #    chaque jour destiné au departement de DRH CERMEL                             #
    #                                                                                 #
    #2- Rapport hebdomadaire de SUDESA avec quelques statistiques et progression du   #
    #   projet                                                                        #
    #                                                                                 #
    #3- Rapport complet SUDESA avec plus details et cartographie de tous les ménages  #
    ###################################################################################
    
    ##Arguments
    ###########
    #Report: Numerical vaule (1, 2, 3)  which will be choose to generate a report in
    #according to your choice.
    
    #Start_date: Character value such as 'YYYY-MM-DD'. It is the starting date which we
    #want to generate your report. By default will be '2016-12-01'.
    
    #end_date: Character value such as 'YYYY-MM-DD'. It is the end date which we
    #want to generate your report. By default will be current date.
    
    #file: Logical value. If it is FALSE
    ###################################################################################
    
    #Defining interactivly the directory of main folder
    ###################################################
    directory <-
      choose.dir(default = "", caption = "Choisir le Dossier SUDESA")
    setwd(directory)
    
    ##Loading the packages
    library(knitr)
    library(rmarkdown)
    
    #Generating the reports
    #######################
    setwd('./Report')
    
    if (report == 1) {
      
      #Generate the report for DRH
      render('SUDESA_Report_1.Rmd', 'pdf_document')
      
      #Rename file template
      file.rename('SUDESA_Report_1.pdf',
                  paste('SUDESA_Report_DRH_', Sys.Date(), '.pdf', sep = ''))
      
      #Remove all SUDESA_Report_1
      AllTimeSheet <-
        list.files(path = getwd(), pattern = "^SUDESA_Report_1")
      file.remove(AllTimeSheet)

      #Remove others files
      OtherFile <-
        list.files(path = getwd(), pattern = ".tex$|.log$|txt$|.aux$")
      file.remove(OtherFile)
      
      
    }
    
    if (report == 2) {
      
      #Generate the report for meeting in Maxime team
      render('SUDESA_Report_2.Rmd', 'pdf_document')
      
      #Rename file template
      file.rename('SUDESA_Report_2.pdf',
                  paste('SUDESA_Report_Summary_', Sys.Date(), '.pdf', sep = ''))
      
      #Remove all SUDESA_Report_1
      AllTimeSheet <-
        list.files(path = getwd(), pattern = "^SUDESA_Report_2")
      file.remove(AllTimeSheet)
      
      #Remove others files
      OtherFile <-
        list.files(path = getwd(), pattern = ".tex$|.log$|txt$|.aux$")
      file.remove(OtherFile)
      
      
    }
    
    if (report == 3) {
      
      #Generate the report for meeting in Maxime team
      render('SUDESA_Report_3.Rmd', 'pdf_document')
      
      #Rename file template
      file.rename('SUDESA_Report_3.pdf',
                  paste('SUDESA_Complete_Report__', Sys.Date(), '.pdf', sep = ''))
      
      #Remove all SUDESA_Report_3
      AllTimeSheet <-
        list.files(path = getwd(), pattern = "^SUDESA_Report_3")
      file.remove(AllTimeSheet)
      
      #Remove others files
      OtherFile <-
        list.files(path = getwd(), pattern = ".tex$|.log$|txt$|.aux$")
      file.remove(OtherFile)
      
      
    }
    
    
    
    
  }