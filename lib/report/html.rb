module Report

  class Html < Reporter
  
    def print(data)
      return if ENV['ENVIRONMENT'] == 'test'
      Dir.mkdir 'tmp' unless File.exist? 'tmp'
      Dir.mkdir ENV['ws.test.reports.path'] unless File.exist? ENV['ws.test.reports.path']

      @app = data[:app_result]
      @ws_config = data[:ws_config]
      @tags = data[:tags]
      @suite_pages = {}
      
      file = "#{ENV['ws.test.reports.path']}/index.html"
      File.open(file, 'w') {|file| file.write _generate_index }
      puts " -- HTML report saved to #{file}" unless ENV['ENVIRONMENT'] == 'test'
      
      @app.suites.each do |suite|
        file = "#{ENV['ws.test.reports.path']}/#{suite.model.name}.html"
        File.open(file, 'w') {|file| file.write _generate_suite suite }
      end
      
      _copy_resources
      
      file
    end
    
    private
    def _copy_resources
      html_path = File.expand_path('../../../html', __FILE__)
      css_path = "#{ENV['ws.test.reports.path']}/css"
      Dir.mkdir css_path unless File.exist? css_path
      
      FileUtils.cp "#{html_path}/bootstrap.min.css", css_path
      
      js_path = "#{ENV['ws.test.reports.path']}/js"
      Dir.mkdir js_path unless File.exist? js_path
      
      FileUtils.cp "#{html_path}/jquery.min.js", js_path
      FileUtils.cp "#{html_path}/bootstrap-collapse.js", js_path
      FileUtils.cp "#{html_path}/Chart.min.js", js_path
    end
    
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
      doc.link :href => "css/bootstrap.min.css", :media => "screen", :rel => "stylesheet", :type => "text/css"
      doc.script :src => 'js/Chart.min.js'
      
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
            @app.suites.each do |suite|
              doc.tr {
                doc.td {
                  doc.a(:href => "#{suite.model.name}.html") { doc.text suite.model.name }
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
              }
            end
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
        doc.canvas(:id => "success_failures_chart", :width => "250", :height => "250")
        doc.script {
          doc.text ChartFactory.pie_chart(:id => 'success_failures_chart', :total_success => @app.total_success, :total_failures => @app.total_failures)
        }
      }
    end
    
    def _generate_suite(suite)
      builder = Nokogiri::HTML::Builder.new do |doc|
        doc.html {
          doc.head { _suite_head doc }
          doc.body {
            _suite_body suite, doc
            doc.script(:src => "js/jquery.min.js", :type => "text/javascript")
            doc.script(:src => "js/bootstrap-collapse.js", :type => "text/javascript")
          }
        }
      end
      
      builder.to_html
    end
    
    def _suite_head(doc)
      doc.meta 'http-equiv' => "Content-Type", :content => "text/html; charset=utf-8"
      doc.title 'Test suite result'
      doc.link :href => "css/bootstrap.min.css", :media => "screen", :rel => "stylesheet", :type => "text/css"
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
          doc.h3 "Test suite: #{suite.model.source.sub(/^#{Regexp.new(ENV['ws.test.models.path'])}\/?/, '')}"
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
        
        doc.div(:class => "row") {
          doc.div(:class => "span3") {
            doc.text 'Description:'
          }
          doc.div(:class => "span9") {
            doc.text suite.model.description
          }
        }
        
        doc.div(:class => "row") {
          doc.div(:class => "span3") {
            doc.text 'Tags:'
          }
          doc.div(:class => "span9") {
            doc.text suite.model.tags.join(', ')
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
        count = 0
        suite.test_results.each do |test|
          doc.div {
            doc.div(:class => "row") {
              doc.div(:class => "alert alert-#{((test.status.success?) ? 'success' : 'error')}") {
                text = "Test ##{count += 1}"
                text << " - #{test.name}" if test.name
                doc.text text
              }
            }
            
            doc.div(:class => "row") {
              doc.div(:class => "span3") {
                doc.text 'Name:'
              }
              doc.div(:class => "span9") {
                doc.text test.name
              }
            }
            
            doc.div(:class => "row") {
              doc.div(:class => "span3") {
                doc.text 'Description:'
              }
              doc.div(:class => "span9") {
                doc.text test.description
              }
            }
            
            doc.div(:class => "row") {
              doc.div(:class => "span3") {
                doc.text 'Tags:'
              }
              doc.div(:class => "span9") {
                txt = ((test.tags.nil?) ? '' : test.tags.join(', '))
                doc.text txt
              }
            }

            doc.div(:class => "row") {
              doc.div(:class => "span3") {
                doc.text 'Status:'
              }
              doc.div(:class => "span9") {
                doc.text ((test.status.success?) ? 'Passed' : 'Failed')
              }
            }
          }
          
          _suite_div_error test, doc if (test.status.error? && !test.error.nil?)
          _suite_div_expectations count, test, doc
          _suite_div_expected_output count, test, doc
        end
      }
    end
    
    def _suite_div_error(test, doc)
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
          doc.text 'Bactrace:'
        }
        doc.div(:class => "span9") {
          doc.pre {
            doc.text test.error[:backtrace]
          }
        }
      }
    end
    
    def _suite_div_expectations(index, test, doc)
      doc.h4 'Test expectations'
     _suite_div_file_expectation index, test, doc
     _suite_div_text_expectations index, test, doc
    end
    
    def _suite_div_file_expectation(index, test, doc)
      if test.test_expectation && test.test_expectation['file']
        doc.div(:class => "row") {
          doc.div(:class => "span3") {
            doc.text 'File:'
          }
          doc.div(:class => "span9") {
            doc.div(:class => "accordion", :id => "accordion_expectation_file_#{index}") {
              doc.div(:class => "accordion-group") {
                doc.div(:class => "accordion-heading") {
                  doc.a(:class => "accordion-toggle", 'data-toggle' => "collapse", 'data-parent' => "#accordion_expectation_file_#{index}", :href => "#collapse_expectation_file_#{index}") {
                    doc.text 'Expand / Collapse'
                  }
                }
                doc.div(:id => "collapse_expectation_file_#{index}", :class => "accordion-body collapse") {
                  doc.div(:class => "accordion-inner") {
                    doc.pre {
                      doc.text _expected_file(test.test_expectation['file'])
                    }
                  }
                }
              }
            }
          }
        }
        
        doc.div(:class => "row") {
          doc.div(:class => "span3") {
            doc.text 'Status:'
          }
          doc.div(:class => "span9") {
            doc.text test.status.test_file_status ? 'Passed' : 'Failed'
          }
        }
        
        doc.br
      end
    end
    
    def _suite_div_text_expectations(index, test, doc)
      if test.test_expectation && test.test_expectation['text']
        _suite_div_text_expectations_equals index, test, doc
        _suite_div_text_expectations_contains index, test, doc
        _suite_div_text_expectations_not_contains index, test, doc
        _suite_div_text_expectations_regex index, test, doc
      end
    end
    
    def _suite_div_text_expectations_equals(index, test, doc)
      return unless test.test_expectation['text']['equals']
      status = ((test.status.test_text_status.nil?) ? 'Not performed' : test.status.test_text_status[:equals])
      status = status ? 'Passed' : 'Failed' unless test.status.test_text_status.nil?
            
      doc.div(:class => "row") {
        doc.div(:class => "span3") {
          doc.text 'Text equals:'
        }
        doc.div(:class => "span9") {
          doc.div(:class => "accordion", :id => "accordion_expectation_text_equals_#{index}") {
            doc.div(:class => "accordion-group") {
              doc.div(:class => "accordion-heading") {
                doc.a(:class => "accordion-toggle", 'data-toggle' => "collapse", 'data-parent' => "#accordion_expectation_text_equals_#{index}", :href => "#collapse_expectation_text_equals_#{index}") {
                  doc.text 'Expand / Collapse'
                }
              }
              doc.div(:id => "collapse_expectation_text_equals_#{index}", :class => "accordion-body collapse") {
                doc.div(:class => "accordion-inner") {
                  doc.pre {
                    doc.text _format_xml(test.test_expectation['text']['equals'])
                  }
                }
              }
            }
          }
        }
      }
      
      doc.div(:class => "row") {
        doc.div(:class => "span3") {
          doc.text 'Status:'
        }
        doc.div(:class => "span9") {
          doc.text status
        }
      }
      
      doc.br
    end
    
    def _suite_div_text_expectations_contains(index, test, doc)
      return unless test.test_expectation['text']['contains']
      status = ((test.status.test_text_status.nil?) ? 'Not performed' : test.status.test_text_status[:contains])
      status = status ? 'Passed' : 'Failed' unless test.status.test_text_status.nil?
            
      doc.div(:class => "row") {
        doc.div(:class => "span3") {
          doc.text 'Text contains:'
        }
        doc.div(:class => "span9") {
          doc.div(:class => "accordion", :id => "accordion_expectation_text_contains_#{index}") {
            doc.div(:class => "accordion-group") {
              doc.div(:class => "accordion-heading") {
                doc.a(:class => "accordion-toggle", 'data-toggle' => "collapse", 'data-parent' => "#accordion_expectation_text_contains_#{index}", :href => "#collapse_expectation_text_contains_#{index}") {
                  doc.text 'Expand / Collapse'
                }
              }
              doc.div(:id => "collapse_expectation_text_contains_#{index}", :class => "accordion-body collapse") {
                doc.div(:class => "accordion-inner") {
                  doc.pre {
                    doc.text test.test_expectation['text']['contains']
                  }
                }
              }
            }
          }
        }
      }
      
      doc.div(:class => "row") {
        doc.div(:class => "span3") {
          doc.text 'Status:'
        }
        doc.div(:class => "span9") {
          doc.text status
        }
      }
      
      doc.br
    end
    
    def _suite_div_text_expectations_not_contains(index, test, doc)
      return unless test.test_expectation['text']['not_contains']
      status = ((test.status.test_text_status.nil?) ? 'Not performed' : test.status.test_text_status[:not_contains])
      status = status ? 'Passed' : 'Failed' unless test.status.test_text_status.nil?
            
      doc.div(:class => "row") {
        doc.div(:class => "span3") {
          doc.text 'Text not contains:'
        }
        doc.div(:class => "span9") {
          doc.div(:class => "accordion", :id => "accordion_expectation_text_not_contains_#{index}") {
            doc.div(:class => "accordion-group") {
              doc.div(:class => "accordion-heading") {
                doc.a(:class => "accordion-toggle", 'data-toggle' => "collapse", 'data-parent' => "#accordion_expectation_text_not_contains_#{index}", :href => "#collapse_expectation_text_not_contains_#{index}") {
                  doc.text 'Expand / Collapse'
                }
              }
              doc.div(:id => "collapse_expectation_text_not_contains_#{index}", :class => "accordion-body collapse") {
                doc.div(:class => "accordion-inner") {
                  doc.pre {
                    doc.text test.test_expectation['text']['not_contains']
                  }
                }
              }
            }
          }
        }
      }
      
      doc.div(:class => "row") {
        doc.div(:class => "span3") {
          doc.text 'Status:'
        }
        doc.div(:class => "span9") {
          doc.text status
        }
      }
      
      doc.br
    end
    
    def _suite_div_text_expectations_regex(index, test, doc)
      return unless test.test_expectation['text']['regex']
      status = ((test.status.test_text_status.nil?) ? 'Not performed' : test.status.test_text_status[:regex])
      status = status ? 'Passed' : 'Failed' unless test.status.test_text_status.nil?
            
      doc.div(:class => "row") {
        doc.div(:class => "span3") {
          doc.text 'Text regex:'
        }
        doc.div(:class => "span9") {
          doc.div(:class => "accordion", :id => "accordion_expectation_text_regex_#{index}") {
            doc.div(:class => "accordion-group") {
              doc.div(:class => "accordion-heading") {
                doc.a(:class => "accordion-toggle", 'data-toggle' => "collapse", 'data-parent' => "#accordion_expectation_text_regex_#{index}", :href => "#collapse_expectation_text_regex_#{index}") {
                  doc.text 'Expand / Collapse'
                }
              }
              doc.div(:id => "collapse_expectation_text_regex_#{index}", :class => "accordion-body collapse") {
                doc.div(:class => "accordion-inner") {
                  doc.pre {
                    doc.text test.test_expectation['text']['regex']
                  }
                }
              }
            }
          }
        }
      }
      
      doc.div(:class => "row") {
        doc.div(:class => "span3") {
          doc.text 'Status:'
        }
        doc.div(:class => "span9") {
          doc.text status
        }
      }
      
      doc.br
    end
    
    def _suite_div_expected_output(index, test, doc)
      doc.h4 'Test output'
      if test.test_actual
        doc.div(:class => "row") {
          doc.div(:class => "span3") { doc.text 'Response:' }
        
          doc.div(:class => "span9") {
            doc.div(:class => "accordion", :id => "accordion_output_test_#{index}") {
              doc.div(:class => "accordion-group") {
                doc.div(:class => "accordion-heading") {
                  doc.a(:class => "accordion-toggle", 'data-toggle' => "collapse",  'data-parent' => "#accordion_output_test_#{index}", :href => "#collapse_output_test_#{index}") {
                    doc.text 'Expand / Collapse'
                  }
                }
                doc.div(:id => "collapse_output_test_#{index}", :class => "accordion-body collapse") {
                  doc.div(:class => "accordion-inner") {
                    doc.pre {
                      doc.text _format_xml(_actual_file test.test_actual)
                    }
                  }
                }
              }
            }
          }
        }
      end
    end

    def _expected_file(expectation)
      return if expectation.nil?
      s = expectation.sub(/^#{Regexp.new(ENV['ws.test.output.files.path'])}/, '')
      file = "#{ENV['ws.test.output.files.path']}/#{s}"
      
      return unless File.exist? file
      
      File.read(file)
    end
    
    def _actual_file(file)
      return unless File.exist? file
      File.read file
    end
    
    def _format_xml(text)
      text = '' unless text
      Nokogiri::XML(text).to_xml
    end
  
  end

end
