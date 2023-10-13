terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
  }
}

# Configure the TencentCloud Provider
provider "tencentcloud" {
    region     = "ap-seoul"
}

# Get availability zones
#data "tencentcloud_availability_zones" "default" {
#}

# add
data "tencentcloud_availability_zones_by_product" "default" {
    product = "cvm"
}
# end of adding



# Get availability images
data "tencentcloud_images" "default" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "centos"
}

# Get availability instance types
data "tencentcloud_instance_types" "default" {
# add
    filter {
        name = "instance-family"
        values = ["S5"]
    }
# end of adding
# modify for Seoul without S5.Small instance change to S5.MRFIUM2
  #cpu_core_count = 1
  #memory_size    = 1

  cpu_core_count = 2
  memory_size    = 2

# end of modifying
}

# Create a web server
resource "tencentcloud_instance" "web" {
  # add 
  depends_on                 = [tencentcloud_security_group_lite_rule.default] 
  # end of adding
  instance_name              = "web server"
  # modify
  #availability_zone          = data.tencentcloud_availability_zones.default.zones.0.name
  availability_zone          = data.tencentcloud_availability_zones_by_product.default.zones.0.name
  # end of modifying
  image_id                   = data.tencentcloud_images.default.images.0.image_id
  instance_type              = data.tencentcloud_instance_types.default.instance_types.0.instance_type
  system_disk_type           = "CLOUD_PREMIUM"
  system_disk_size           = 50
  allocate_public_ip         = true
  internet_max_bandwidth_out = 20
  # add
  instance_charge_type = "POSTPAID_BY_HOUR"
  # end of adding
  # marked 
  #security_groups            = [tencentcloud_security_group.default.id]
  #
  # add to 
  orderly_security_groups    = [tencentcloud_security_group.default.id]
  # end of adding
  count                      = 1
}

# Create security group
resource "tencentcloud_security_group" "default" {
  name        = "web accessibility"
  description = "make it accessible for both production and stage ports"
}

# # Create security group rule allow web request
# resource "tencentcloud_security_group_rule" "web" {
#   security_group_id = tencentcloud_security_group.default.id
#   type              = "ingress"
#   cidr_ip           = "0.0.0.0/0"
#   ip_protocol       = "tcp"
#   port_range        = "80,8080"
#   policy            = "accept"
# }

# # Create security group rule allow ssh request
# resource "tencentcloud_security_group_rule" "ssh" {
#   security_group_id = tencentcloud_security_group.default.id
#   type              = "ingress"
#   cidr_ip           = "0.0.0.0/0"
#   ip_protocol       = "tcp"
#   port_range        = "22"
#   policy            = "accept"
# }


#add
resource "tencentcloud_security_group_lite_rule" "default" {
    security_group_id = tencentcloud_security_group.default.id
    ingress = [
        "ACCEPT#0.0.0.0/0#22#TCP",
        "ACCEPT#0.0.0.0/0#6443#TCP",
    ]
    egress = [
        "ACCEPT#0.0.0.0/0#ALL#ALL"
    ]
} 
#end of adding



######

#data "tencentcloud_images" "my_favorite_image" {
#  image_type       = ["PUBLIC_IMAGE"]
#  image_name_regex = "Final"
#}

#data "tencentcloud_instance_types" "my_favorite_instance_types" {
#  filter {
#    name   = "instance-family"
#    values = ["S1", "S2", "S3", "S4", "S5"]
#  }
#
#  cpu_core_count   = 2
#  exclude_sold_out = true
#}

#data "tencentcloud_availability_zones" "my_favorite_zones" {
#}

// Create VPC resource
#resource "tencentcloud_vpc" "app" {
#  cidr_block = "10.0.0.0/16"
#  name       = "awesome_app_vpc"
#}

#resource "tencentcloud_subnet" "app" {
#  vpc_id            = tencentcloud_vpc.app.id
#  availability_zone = data.tencentcloud_availability_zones.my_favorite_zones.zones.0.name
#  name              = "awesome_app_subnet"
#  cidr_block        = "10.0.1.0/24"
#}

// Create a POSTPAID_BY_HOUR CVM instance
#resource "tencentcloud_instance" "cvm_postpaid" {
#  instance_name     = "cvm_postpaid"
#  availability_zone = data.tencentcloud_availability_zones.my_favorite_zones.zones.0.name
#  image_id          = data.tencentcloud_images.my_favorite_image.images.0.image_id
#  instance_type     = data.tencentcloud_instance_types.my_favorite_instance_types.instance_types.0.instance_type
#  system_disk_type  = "CLOUD_PREMIUM"
#  system_disk_size  = 50
#  hostname          = "user"
#  project_id        = 0
#  vpc_id            = tencentcloud_vpc.app.id
#  subnet_id         = tencentcloud_subnet.app.id

#  data_disks {
#    data_disk_type = "CLOUD_PREMIUM"
#    data_disk_size = 50
#    encrypt        = false
# }

#  tags = {
#    tagKey = "tagValue"
#  }
#}

