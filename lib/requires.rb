require 'yaml'
require 'logging'
require 'savon'

require File.expand_path  '../../lib/config/app_config_params.rb', __FILE__
require File.expand_path  '../../lib/config/app_logger.rb', __FILE__
require File.expand_path  '../../lib/helper/app_helper.rb', __FILE__
require File.expand_path '../../lib/engine/execution_initializer.rb', __FILE__
require File.expand_path '../../lib/engine/parser.rb', __FILE__
require File.expand_path '../../lib/engine/executor.rb', __FILE__
require File.expand_path '../../lib/engine/soap_executor.rb', __FILE__
require File.expand_path '../../lib/model/execution.rb', __FILE__
require File.expand_path '../../lib/model/test_app_result.rb', __FILE__
require File.expand_path '../../lib/model/test.rb', __FILE__
require File.expand_path '../../lib/model/test_result.rb', __FILE__
require File.expand_path '../../lib/model/test_status.rb', __FILE__
require File.expand_path '../../lib/model/test_suite.rb', __FILE__
require File.expand_path '../../lib/model/test_suite_result.rb', __FILE__
require File.expand_path '../../lib/model/text_operator.rb', __FILE__
require File.expand_path '../../lib/model/ws_config.rb', __FILE__
require File.expand_path '../../lib/net/soap_net.rb', __FILE__

include Model
include Configuration
include Engine
include Helper
include Net
