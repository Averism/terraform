variable "appname" {
    type = string
}

variable "verification_email_arn" {
    type = string
}

resource "aws_cognito_user_pool" "pool" {
  name = var.appname
  sms_authentication_message = "Your authentication code is {####}. "
  
  alias_attributes = [
    "email",
    "phone_number",
  ] 
  

  schema {     
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
        max_length = "2048"
        min_length = "0"
    }
  }
  schema {     
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "name"
    required                 = true

    string_attribute_constraints {
        max_length = "2048"
        min_length = "0"
    }
  }
  
  schema {     
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "privatekey"
    required                 = false

    string_attribute_constraints {
        max_length = "256"
        min_length = "1"
    }
  }
    schema {     
    attribute_data_type      = "Number"
    developer_only_attribute = false
    mutable                  = true
    name                     = "pk"
    required                 = false

    number_attribute_constraints {
        max_value = "999999999999999"
        min_value = "0"
    }
  }
  schema {     
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false
    name                     = "pvkseed"
    required                 = false

    string_attribute_constraints {
        max_length = "256"
        min_length = "8"
    }
  }
  
  auto_verified_attributes   = [
    "email",
  ]
  
  device_configuration {
    challenge_required_on_new_device      = false
    device_only_remembered_on_user_prompt = false
  }
  
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
    source_arn            = var.verification_email_arn
  }
  
}