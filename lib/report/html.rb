module Report

  class Html < Reporter
  
    def print(data)
      Dir.mkdir 'tmp' unless File.exist? 'tmp'
      Dir.mkdir ENV['ws.test.reports.path'] unless File.exist? ENV['ws.test.reports.path']

      @app = data[:app_result]
      @ws_config = data[:ws_config]
      @tags = data[:tags]
      
      file = "#{ENV['ws.test.reports.path']}/index.html"
      File.open(file, 'w') {|file| file.write _generate_index }
      
      @app.suites.each do |suite|
        name = suite.model.source
        file_name = name[name.rindex('/') + 1, name.size]
        file = "#{ENV['ws.test.reports.path']}/#{file_name}.html"
        File.open(file, 'w') {|file| file.write _generate_suite suite }
      end
      
      puts " -- HTML report saved to #{file}" unless ENV['ENVIRONMENT'] == 'test'
      file
    end
    
    private
    def _generate_index
      builder = Nokogiri::HTML::Builder.new do |doc|
        doc.html {
          doc.head { _index_head doc }
          doc.body { _index_body doc }
        }
      end
      
      builder.to_html
    end
    
    def _index_head(doc)
      doc.meta 'http-equiv' => "Content-Type", :content => "text/html; charset=utf-8"
      doc.title 'Web Service Tests Report'
      doc.link :href => "http://getbootstrap.com/2.3.2/assets/css/bootstrap.css", :media => "screen", :rel => "stylesheet", :type => "text/css"
    end
    
    def _index_body(doc)
      doc.div(:class => 'container') {
        doc.div(:id => "div_capa", :class => "well", :align => "center") {
          doc.h2 'Web Service Tests Report'
          doc.p "Report date #{@app.date_report}"
        }
        _index_div_result doc
        _index_div_introduction doc
        _index_div_metadata doc
        _index_div_report doc
      }
    end
    
    def _index_div_result(doc)
      if @app.success?
        doc.div(:class => "alert alert-success") {
          doc.h3 'Success! All tests have passed'
        }
      else
        doc.div(:class => "alert alert-error") {
          doc.h3 "Failure! (total failures) broken test(s)"
        }
      end
    end
    
    def _index_div_introduction(doc)
      doc.div(:id => "div_introduction") {
        doc.h3 "1 - Overview"
        doc.text "Project of automated testing of web service. " +
          "Actually #{@app.suites.size} test suite(s) is(are) implemented, " +
          "totaling #{@app.total_test_cases} test case(s)."
      }
    end
    
    def _index_div_metadata(doc)
      doc.div(:id => "div_meta-data") {
        doc.h3 '2 - Metadata'
        doc.h4 '2.1 - WS Config'
        doc.div(:id => "div_ws_config") {
          WsConfig.ws_attributes.each do |p|
            doc.div(:class => "row") {
              doc.div(:class => "span3") {
                doc.text "#{p}:"
              }
              doc.div(:class => "span6") {
                doc.text @ws_config.instance_eval p
              }
            }
          end
        }
        doc.h4 '2.2 - Tags'
        doc.div(:id => "div_tags") {
          doc.div(:class => 'row') {
            doc.div(:class => 'span9') {
              doc.text ((@tags.nil?) ? '-' : @tags.join(', '))
            }
          }
        }
      }
    end
    
    def _index_div_report(doc)
      doc.div(:id => "div_report") {
        doc.h3 '3 - Report'
        doc.h4 '3.1 - Aggregated data'
        doc.table(:class => "table table-bordered table-hover") {
          doc.theader {
            doc.tr {
              doc.th(:rowspan => "2") { doc.text 'Test Suites' }
              doc.th(:colspan => "3") { doc.text 'Test Cases' }
            }
            doc.tr {
              doc.th 'Success'
              doc.th 'Failures'
              doc.th 'Total'
            }
          }
          doc.tbody {
            doc.tr {
              @app.suites.each do |suite|
                doc.td {
                  doc.a(:href => '')
                }
                doc.td {
                  doc.text suite.total_success
                }
                doc.td {
                  doc.text suite.total_failures
                }
                doc.td {
                  doc.text suite.test_results.size
                }
              end
            }
          }
          doc.tfooter {
            doc.tr {
              doc.th @app.total_suites
              doc.th @app.total_success
              doc.th @app.total_failures
              doc.th @app.total_test_cases
            }
          }
        }
        
        doc.h4 '3.2 - Statistics'
        doc.h5 '3.2.1 - Success x Failures'
        doc.div(:id => "chart_div_success_failure")
        doc.h5 '3.2.2 - Test cases implementation'
        doc.div(:id => "chart_div_test_implementation")
      }
    end
    
    def _generate_suite(suite)
      builder = Nokogiri::HTML::Builder.new do |doc|
        doc.html {
          doc.head { _suite_head doc }
          doc.body {
            _suite_body suite, doc
            doc.script(:src => "http://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js",
              :type => "text/javascript")
            doc.script(:src => "http://getbootstrap.com/2.3.2/assets/js/bootstrap-collapse.js",
              :type => "text/javascript")
          }
        }
      end
      
      builder.to_html
    end
    
    def _suite_head(doc)
      doc.meta 'http-equiv' => "Content-Type", :content => "text/html; charset=utf-8"
      doc.title 'Test suite result'
      doc.link :href => "stylesheets/bootstrap.min.css", :media => "screen", :rel => "stylesheet", :type => "text/css"
    end
    
    def _suite_body(suite, doc)
      doc.div(:class => "container") {
        doc.div(:id => "div_capa", :class => "well", :align => "center") {
          doc.h2 'Test suite report'
          doc.text "Report date #{@app.date_report}"
        }
        
        _suite_div_introduction suite, doc
        _suite_div_overview suite, doc
        _suite_div_tests suite, doc
        
        doc.a(:href => "index.html", :class => "btn btn-primary btn-large") { doc.text 'Voltar' }
      }
    end
    
    def _suite_div_introduction(suite, doc)
      doc.div(:id => "div_introducao") {
        doc.div(:class => "alert alert-#{((suite.success?) ? 'success' : 'error')}") {
          doc.h3 "Test suite: #{suite.model.source}"
        }
        
        doc.div(:class => "row") {
          doc.div(:class => "span3") {
            doc.text 'WSDL:'
          }
          doc.div(:class => "span9") {
            doc.text suite.model.wsdl
          }
        }
        
        doc.div(:class => "row") {
          doc.div(:class => "span3") {
            doc.text 'Service:'
          }
          doc.div(:class => "span9") {
            doc.text suite.model.service
          }
        }
      }
    end
    
    def _suite_div_overview(suite, doc)
      doc.div(:id => "div_overview") {
        doc.h3 'Overview'
        doc.div(:class => "row") {
          doc.div(:class => 'span3') {
            doc.text 'Test cases'
          }
          doc.div(:class => 'span9') {
            suite.test_results.size
          }
        }
        
        doc.div(:class => "row") {
          doc.div(:class => "span3") {
            doc.text 'Success:'
          }
          doc.div(:class => "span9") {
            doc.text suite.total_success
          }
        }
        
        doc.div(:class => "row") {
          doc.div(:class => "span3") {
            doc.text 'Falha:'
          }
          doc.div(:class => "span9") {
            doc.text suite.total_failures
          }
        }
      }
    end
    
    def _suite_div_tests(suite, doc)
      doc.div(:id => "div_tests") {
        doc.h3 'Test cases'
        suite.test_results.each do |test|
          doc.div {
            doc.div(:class => "row") {
              doc.div(:class => "alert alert-#{((test.status.success?) ? 'success' : 'error')}") {
                doc.text "Test - ##{test.name}"
              }
            }

            doc.div(:class => "row") {
              doc.div(:class => "span3") {
                'Status:'
              }
              doc.div(:class => "span9") {
                doc.text ((test.status.success?) ? 'Passed' : 'Failed')
              }
            }
          }  
        end
      }
    end
  
  end

end







unless test.status.success?
              doc.h4 'Error'
              doc.div(:class => "row") {
                doc.div(:class => "span3") {
                  doc.text 'Message:'
                }
                doc.div(:class => "span9") {
                  doc.text test.error[:message]
                }
              }

              doc.div(:class => "row") {
                doc.div(:class => "span3") {
                  doc.text 'Retorno:'
                }
                doc.div(:class => "span9") {
                  doc.pre {
                    doc.text format_xml test.error[:backtrace]
                  }
                }
              }
            end

doc.h4 'Test expectations'
            if test.test_expectation
              if test.test_expectation['file']
                doc.div(:class => "row") {
                  doc.div(:class => "span3") {
                    doc.text 'File:'
                  }
                  doc.div(:class => "span9") {
                    doc.div(:class => "accordion", :id => "accordion_expectation_file_#{test.name}") {
                      doc.div(:class => "accordion-group") {
                        doc.div(:class => "accordion-heading") {
                          doc.a(:class => "accordion-toggle", 'data-toggle' => "collapse", 'data-parent' => "#accordion_expectation_file_#{test.name}", :href => "#collapse_expectation_file_#{test.name}") {
                            doc.text 'Expandir / Recolher'
                          }
                        }
                        doc.div(:id => "collapse_expectation_file_#{test.name}", :class => "accordion-body collapse") {
                          doc.div(:class => "accordion-inner") {
                            doc.pre {
                              doc.text expected_file(test.test_expectation['file'])
                            }
                          }
                        }
                      }
                    }
                  }
                }
              elsif test.test_expectation['text']
              
              end
            end
