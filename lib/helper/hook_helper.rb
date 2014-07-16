HOOKS = {}

def before_app(&block)
  if HOOKS[:before_app].nil?
    HOOKS[:before_app] = [block]
  else
    HOOKS[:before_app] << block
  end
end

def after_app(&block)
  if HOOKS[:after_app].nil?
    HOOKS[:after_app] = [block]
  else
    HOOKS[:after_app] << block
  end
end

def before_suite(&block)
  if HOOKS[:before_suite].nil?
    HOOKS[:before_suite] = [block]
  else
    HOOKS[:before_suite] << block
  end
end

def after_suite(&block)
  if HOOKS[:after_suite].nil?
    HOOKS[:after_suite] = [block]
  else
    HOOKS[:after_suite] << block
  end
end

def before_test(&block)
  if HOOKS[:before_test].nil?
    HOOKS[:before_test] = [block]
  else
    HOOKS[:before_test] << block
  end
end

def after_test(&block)
  if HOOKS[:after_test].nil?
    HOOKS[:after_test] = [block]
  else
    HOOKS[:after_test] << block
  end
end

Dir.glob(File.join(Dir.pwd, "support", "**", "*.rb")).each {|file| require file }
