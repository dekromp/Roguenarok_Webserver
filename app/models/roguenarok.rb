class Roguenarok < ActiveRecord::Base
  has_many :taxon
  belongs_to :user
  
  attr_accessor :bootstrap_tree_set, :tree, :excluded_taxa, :taxa_file
  ### Standard validator functions
  validates_presence_of :bootstrap_tree_set, :message =>"cannot be blank!"


  ### custom validator function that checks file formats of the uploaded files
  def validate
    jobdir = "#{RAILS_ROOT}/public/jobs/#{self.jobid}/"

    #validate bootstrap treeset file
    if !self.bootstrap_tree_set.nil?
      b = TreeFileParser.new(self.bootstrap_tree_set)
      errors.add(:bootstrap_tree_set, b.error) if !b.valid_format
      if b.valid_format
        bts_path = jobdir+"bootstrap_treeset_file"
        saveOnDisk(b.data, bts_path)
        self.bootstrap_tree_set = bts_path
        # build taxa file and check if everything worked out
        self.taxa_file = b.buildTaxaFile(self.jobid, bts_path)
        errors.add(:bootstrap_tree_set, b.error) if !b.valid_format
      end
    end

    # validate tree file
    if !self.tree.eql?("") 
      t = TreeFileParser.new(self.tree)
      errors.add(:tree, t.error) if !t.valid_format
      if t.valid_format
        tree_path = jobdir+"best_tree"
        saveOnDisk(t.data, tree_path)
        self.tree = tree_path
      end
    end

    # validate excluded taxa file
    if !self.excluded_taxa.nil?
      e = ExcludedTaxaFileParser.new(self.excluded_taxa)
      errors.add(:excluded_taxa, e.error) if !e.valid_format
      if e.valid_format
        excluded_taxa_path = jobdir+"excluded_taxa"
        saveOnDisk(e.data, excluded_taxa_path)
        self.excluded_taxa = excluded_taxa_path

      end
    end

  end

  def saveOnDisk(data,path)
    File.open(path,'wb'){|f| f.write(data.join)}
  end

  def excludeTaxa(list)
    self.excluded_taxa = File.join(RAILS_ROOT,"public","jobs",self.jobid,"excluded_taxa")
    ex_taxa = []
    list.each do |name|
      puts name
      name = name.sub(/^<del>/, '')
      name = name.sub(/<\/del>$/,'')
      ex_taxa.push( Taxon.find(:first, :conditions => {:roguenarok_id => self.id, :name => name.chomp} ))
    end
    ex_taxa.each do |t|
      t.update_attributes(:excluded => 'T')
    end

    # update excluded taxa file
    taxa = Taxon.find(:all, :conditions => {:roguenarok_id => self.id, :excluded => 'T'} )
    f = File.open(self.excluded_taxa, 'wb')
    taxa.each do |taxon|
      f.write(taxon.name+"\n")
    end
    f.close
  end

  def includeTaxa(list)
    inc_taxa = []
    list.each do |name|
      name = name.sub(/^<del>/, '')
      name = name.sub(/<\/del>$/,'')
      inc_taxa.push( Taxon.find(:first, :conditions => {:roguenarok_id => self.id, :name => name.chomp} ))
    end
    inc_taxa.each do |t|
      t.update_attributes(:excluded => 'F')
    end

    # update excluded taxa file
    taxa = Taxon.find(:all, :conditions => {:roguenarok_id => self.id, :excluded => 'T'} )
    f = File.open(self.excluded_taxa, 'wb')
    taxa.each do |taxon|
      f.write(taxon.name+"\n")
    end
    f.close
  end
  
  def Roguenarok.sendMessage(name,email,subject,message)  
    command = File.join(RAILS_ROOT,"bioprogs","ruby","send_message.rb")
    if !(name.nil? || name.eql?(""))
      command = command+" -n #{name} "
    end
    if email=~/^\S+@\S+/
      command = command+" -e #{email} "
    end
    if !(subject.nil? || subject.eql?(""))
      command = command+" -s #{subject} "
    end
    command = command+" -m #{message} "
    system command # if more traffic on the server is occuring (at this moment, the server can handle three parallel requests)  this should be submitted to the batch system
    return true
  end

 end
