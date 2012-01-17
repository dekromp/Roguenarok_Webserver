class RogueTaxaAnalysis < ActiveRecord::Base

  attr_accessor :jobid, :threshold, :user_def, :optimize, :dropset

  #validates_presence_of :dropset
  HUMANIZED_ATTRIBUTES = {
    :jobid => "Job ID", :threshold => "Threshold", :user_def => "User defined value", :optimize => "Optimize", :dropset => "Dropset"
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end


  def validate

    # validate dropset, not nil, has to be an integer
    if self.dropset.nil? || self.dropset.empty? 
      self.errors.add(:dropset, "cannot be blank!")
    else
      if self.dropset =~ /^(\d+)$/ 
        d = $1.to_i
        if d < 1
          self.errors.add(:dropset, "must be greater than zero!")
        end
      else
        self.errors.add(:dropset, "must be an integer greater than zero!")
      end
    end

    # validate threshold user defined value, has to be an integer, nil allowed if not selected
    if threshold.eql?('user')
      if self.user_def.nil? || self.user_def.empty? 
        self.errors.add(:user_def, "cannot be blank!")
      else
        if self.user_def =~ /^(\d+)$/ 
          d = $1.to_i
          if d < 50 || d > 100
            self.errors.add(:user_def, "must be between 50 and 100")
          end
        else
          self.errors.add(:user_def, "must be an integer greater than zero!")
        end
      end
    end
    
  end

  def execute(link)
    path                   = File.join(RAILS_ROOT,"public","jobs",self.jobid)
    bootstrap_treeset_file = File.join(path, "bootstrap_treeset_file")
    best_tree_file         = File.join(path, "best_tree")
    excluded_taxa_file     = File.join(path,"excluded_taxa")
    results_path           = File.join(path,"results")
    logs_path              = File.join(path,"logs")

    current_logfile = File.join(path,"current.log")
    if File.exists?(current_logfile) 
      system "rm #{current_logfile}"
    end

    # BOOTSTRAP TREESET, DROPSET, NAME, WORKING DIRECTORY
    opts = {
      "-i" => bootstrap_treeset_file, 
      "-s" => self.dropset, 
      "-n" => "#{self.jobid}_#{self.id}",
      "-w" => path}
    
    # THRESHOLD
    if self.threshold.eql?("mr")
      opts["-c"] = 50
    elsif self.threshold.eql?("mre")
      otps["-c"] = "MRE"
    elsif self.threshold.eql?("user")
      opts["-c"] = self.user_def
    elsif self.threshold.eql?("strict")
      opts["-c"] = 100
    else # bipartitions
      opts["-t"] = best_tree_file
    end
    
    # OPTIMIZATION
    if self.optimize.eql?("number_of_bipartitions")
      opts["-b"] = ""
    end

    # EXCLUDED TAXA
    if File.exists?(excluded_taxa_file)
      opts["-x"] = excluded_taxa_file
    end
    
    job = Roguenarok.find(:first,:conditions => {:jobid => self.jobid})
    user = User.find(:first, :conditions => {:id => job.user_id})
    email = user.email

    # BUILD SHELL FILE FOR QSUB

    shell_file =File.join(RAILS_ROOT,"public","jobs",self.jobid,"submit.sh")

    command_create_results_folder = "mkdir #{results_path}"
    if File.exists?(results_path) && File.directory?(results_path)
      command_create_results_folder = ""
    end

    command_create_logs_folder = "mkdir #{logs_path}"
    if File.exists?(logs_path) && File.directory?(logs_path)
      command_create_logs_folder = ""
    end

    command_roguenarok = File.join(RAILS_ROOT,"bioprogs","roguenarok","RogueNaRok")
    opts.each_key {|k| command_roguenarok  = command_roguenarok+" "+k+" #{opts[k]} "}

    resultfiles = File.join(path,"RogueNaRok*")
    command_save_result_files="mv #{resultfiles} #{results_path}"

    logfiles = File.join(path,"submit.sh.*")
    command_save_log_files = "cp #{logfiles} #{current_logfile};mv #{logfiles} #{logs_path}"

    command_send_email = "";
    if !(email.nil? || email.empty?)
      command_send_email = File.join(RAILS_ROOT,"bioprogs","ruby","send_email.rb")
      command_send_email = command_send_email + " -e #{email} -l #{link}"
    end
  
    File.open(shell_file,'wb'){|file| 
      file.write(command_create_results_folder+"\n")
      file.write(command_create_logs_folder+"\n")
      file.write(command_roguenarok+"\n")
      file.write(command_save_result_files+"\n")
      file.write(command_send_email+"\n")
      file.write("echo done!\n")
      file.write(command_save_log_files+"\n")
    }

    # submit shellfile into batch system 
    system "qsub -o #{path} -j y #{shell_file} "
  end
end
