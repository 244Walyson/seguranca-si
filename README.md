# Terraform - EC2 para Ferramentas de Rede

Este projeto Terraform provisiona uma instância EC2 na AWS configurada para executar comandos de rede.

## Recursos Criados

- VPC com subnet pública
- Internet Gateway
- Security Group com acesso SSH e ICMP
- Instância EC2 com ferramentas de rede pré-instaladas

## Ferramentas Instaladas

- tcpdump
- nmap
- traceroute
- telnet
- netcat (nc)
- dig/nslookup (bind-utils)
- iperf3
- mtr

## Pré-requisitos

1. Terraform instalado
2. AWS CLI configurado com credenciais
3. Par de chaves SSH (será criado se não existir)

## Como Usar

1. Gere um par de chaves SSH (se ainda não tiver):

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
```

2. Copie o arquivo de exemplo e ajuste as variáveis:

```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Inicialize o Terraform:

```bash
terraform init
```

4. Revise o plano:

```bash
terraform plan
```

5. Aplique a configuração:

```bash
terraform apply
```

6. Conecte-se à instância:

```bash
ssh -i ~/.ssh/id_rsa ec2-user@<IP_PUBLICO>
```

## Exemplos de Comandos de Rede

Após conectar na instância:

```bash
# Ping
ping google.com

# Traceroute
traceroute google.com

# Scan de portas
nmap -p 80,443 example.com

# DNS lookup
dig google.com

# Captura de pacotes
sudo tcpdump -i eth0

# Test de banda
iperf3 -c iperf.he.net
```

## Limpeza

Para destruir todos os recursos:

```bash
terraform destroy
```

## Segurança

Por padrão, o SSH está aberto para 0.0.0.0/0. Para maior segurança, altere `allowed_ssh_cidr` em `terraform.tfvars` para seu IP específico.
