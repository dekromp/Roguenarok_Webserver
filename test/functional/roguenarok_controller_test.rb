require 'test_helper'

class RoguenarokControllerTest < ActionController::TestCase
  
  


  def test_index
    get :index
    assert_response :success
  end

  def test_submit
    get :submit
    assert_response :success
  end

  def test_upload         
    
     # Testfiles for upload
    @bootstrap_treeset_valid = "#{RAILS_ROOT}/testfiles/1-bootstrap_treeset_128taxa.bts"
    @bootstrap_treeset_error = "#{RAILS_ROOT}/testfiles/Error1-bootstrap_treeset_128taxa.bts"
    @best_known_tree_valid   = "#{RAILS_ROOT}/testfiles/1-Tree_128taxa.newick"
    @best_known_tree_error   = "#{RAILS_ROOT}/testfiles/Error1-Tree_128taxa.newick"
    @taxa_excluded_valid     = "#{RAILS_ROOT}/testfiles/1-excluded_taxa.ex"
    @taxa_excluded_error1    = "#{RAILS_ROOT}/testfiles/Error1-excluded_taxa.ex"
    @taxa_excluded_error2    = "#{RAILS_ROOT}/testfiles/Error2-excluded_taxa.ex"
    @email_valid             = "Roguenarok@thismachine.org"
    @email_error             = "Roguenarok"
     
    # positive tests
    File.open(@bootstrap_treeset_valid,'r')
    puts "### v,x,x,x,x"
    assert submit_upload(@bootstrap_treeset_valid,"","","","")
    puts "### v,v,v,v,v"
    assert submit_upload(@bootstrap_treeset_valid,@best_known_tree_valid,@taxa_excluded_valid,"blablablba",@email_valid)
    puts "### v,x,x,x,v"
    assert submit_upload(@bootstrap_treeset_valid,"","","",@email_valid)
    
    # negative tests
    puts "### f,x,x,x,x"
    assert !submit_upload(@bootstrap_treeset_error,"","","","")
    puts "### v,f,x,x,x"
    assert !submit_upload(@bootstrap_treeset_valid,@best_known_tree_error,"","","")
    puts "### v,x,f,x,x"
    assert !submit_upload(@bootstrap_treeset_valid,"",@taxa_excluded_error1,"","")
    puts "### v,x,x,f,x"
    assert !submit_upload(@bootstrap_treeset_valid,"",@taxa_excluded_error2,"","")
    puts "### v,x,x,x,f"
    assert !submit_upload(@bootstrap_treeset_valid,"","","",@email_error)

  end

  private 
  def submit_upload(bootstrap_treeset, best_known_tree, excluded_taxa, description, email)
    a =  post :upload,
    :bootstrap_tree_set => {:file => bootstrap_treeset},
    :best_known_tree => {:file => best_known_tree},
    :taxa_to_exclude => {:file => excluded_taxa},
    :description => description,
    :email => {:email_address => email}
    puts "######{a.location}#####"
    if a.message.eql?("Found") #redirected to 'work'
      return true
    else #OK#                  #rendering 'submit' in case of an error
      return false
    end
  end
end
