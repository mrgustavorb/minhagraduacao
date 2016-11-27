module ResearchHelper

  def rating_form(title, input_name, param_value = nil)
    <<-ERB
      <div class="form-group">    
        <label class="col-lg-5 col-md-5 control-label" style="padding-top: 8px;"><span style="color: #700A0A">*</span>  #{title}</label>    
        <div class="col-lg-7 col-md-7">
        
          <div class="input select rating-c">
            <select class="example-c" name="#{input_name}">
              <option value=""></option>
              <option value="0" #{(param_value == '0') ? 'selected="selected"' : ''} >0</option>
              <option value="1" #{(param_value == '1') ? 'selected="selected"' : ''} >1</option>
              <option value="2" #{(param_value == '2') ? 'selected="selected"' : ''} >2</option>
              <option value="3" #{(param_value == '3') ? 'selected="selected"' : ''} >3</option>
              <option value="4" #{(param_value == '4') ? 'selected="selected"' : ''} >4</option>
              <option value="5" #{(param_value == '5') ? 'selected="selected"' : ''} >5</option>
              <option value="6" #{(param_value == '6') ? 'selected="selected"' : ''} >6</option>
              <option value="7" #{(param_value == '7') ? 'selected="selected"' : ''} >7</option>
              <option value="8" #{(param_value == '8') ? 'selected="selected"' : ''} >8</option>
              <option value="9" #{(param_value == '9') ? 'selected="selected"' : ''} >9</option>
              <option value="10" #{(param_value == '10') ? 'selected="selected"' : ''} >10</option>
            </select>
          </div>   

        </div>   
      </div>
    ERB
    .html_safe
  end

  def what_salary?(rating_salary, professional = false)
    salary = case rating_salary 
      when 0 
        "--"
      when 1 
        "Até R$ 1.000,00"
      when 2 
        "R$ 1.000,00 a R$ 2.000,00"
      when 3 
        "R$ 2.000,00 a R$ 3.000,00"
      when 4 
        "R$ 3.000,00 a R$ 4.000,00"
      when 5 
        "R$ 4.000,00 a R$ 5.000,00"  
      when 6 
        "Acima de R$ 5.000,00" 
    end 

    if professional
      salary = case rating_salary 
        when 0 
          "--"
        when 1 
          "Até R$ 2.000,00"
        when 2 
          "R$ 2.000,00 a R$ 3.000,00"
        when 3 
          "R$ 3.000,00 a R$ 4.000,00"
        when 4 
          "R$ 4.000,00 a R$ 5.000,00"
        when 5 
          "R$ 5.000,00 a R$ 7.000,00"  
        when 6 
          "R$ 7.000,00 a R$ 10.000,00"  
        when 7 
          "Acima de R$ 10.000,00" 
      end
    end

    salary
  end

end