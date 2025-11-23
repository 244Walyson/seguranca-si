variable "aws_region" {
  description = "Regiao AWS"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo da instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "create_key_pair" {
  description = "Criar novo key pair ou usar existente"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "Nome da chave SSH a ser criada"
  type        = string
  default     = "network-tools-key"
}

variable "existing_key_name" {
  description = "Nome de uma chave SSH existente na AWS (usado se create_key_pair = false)"
  type        = string
  default     = ""
}

variable "public_key_path" {
  description = "Caminho para a chave publica SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks permitidos para SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
