# Terraform - EC2 para Ferramentas de Rede

Este projeto Terraform provisiona uma instância EC2 na AWS configurada para executar comandos de rede.

## Arquitetura da Infraestrutura

```
┌─────────────────────────────────────────────────────────────────┐
│                          AWS Cloud                              │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │ VPC (10.0.0.0/16)                                         │ │
│  │                                                           │ │
│  │  ┌─────────────────────────────────────────────────────┐ │ │
│  │  │ Subnet Pública (10.0.1.0/24)                        │ │ │
│  │  │                                                     │ │ │
│  │  │  ┌──────────────────────────────────────────────┐  │ │ │
│  │  │  │ EC2 Instance (Amazon Linux 2)                │  │ │ │
│  │  │  │                                              │  │ │ │
│  │  │  │ - Public IP: Auto-assigned                   │  │ │ │
│  │  │  │ - Instance Type: t2.micro                    │  │ │ │
│  │  │  │                                              │  │ │ │
│  │  │  │ Ferramentas Instaladas:                      │  │ │ │
│  │  │  │ • tcpdump    • nmap                          │  │ │ │
│  │  │  │ • traceroute • telnet                        │  │ │ │
│  │  │  │ • netcat     • dig/nslookup                  │  │ │ │
│  │  │  │ • iperf3     • mtr                           │  │ │ │
│  │  │  └──────────────────────────────────────────────┘  │ │ │
│  │  │                        │                            │ │ │
│  │  │                        │                            │ │ │
│  │  │  ┌─────────────────────▼──────────────────────┐    │ │ │
│  │  │  │ Security Group                             │    │ │ │
│  │  │  │                                            │    │ │ │
│  │  │  │ Inbound:                                   │    │ │ │
│  │  │  │ • SSH (22/tcp)    from 0.0.0.0/0          │    │ │ │
│  │  │  │ • ICMP (ping)     from 0.0.0.0/0          │    │ │ │
│  │  │  │                                            │    │ │ │
│  │  │  │ Outbound:                                  │    │ │ │
│  │  │  │ • All traffic     to 0.0.0.0/0            │    │ │ │
│  │  │  └────────────────────────────────────────────┘    │ │ │
│  │  │                                                     │ │ │
│  │  └─────────────────────────────────────────────────────┘ │ │
│  │                              │                            │ │
│  │                              │                            │ │
│  │  ┌───────────────────────────▼──────────────────────────┐ │ │
│  │  │ Route Table                                          │ │ │
│  │  │ • 10.0.0.0/16 → local                               │ │ │
│  │  │ • 0.0.0.0/0   → Internet Gateway                    │ │ │
│  │  └──────────────────────────────────────────────────────┘ │ │
│  │                              │                            │ │
│  └──────────────────────────────┼────────────────────────────┘ │
│                                 │                              │
│  ┌──────────────────────────────▼────────────────────────────┐ │
│  │ Internet Gateway                                          │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                 │                              │
└─────────────────────────────────┼──────────────────────────────┘
                                  │
                                  │
                    ┌─────────────▼─────────────┐
                    │   Internet (Public)       │
                    │                           │
                    │   SSH Access via:         │
                    │   ssh ec2-user@<PUBLIC_IP>│
                    └───────────────────────────┘
```

## Recursos Criados

- **VPC** (10.0.0.0/16) - Rede virtual isolada
- **Subnet Pública** (10.0.1.0/24) - Subnet com acesso à internet
- **Internet Gateway** - Permite comunicação com a internet
- **Route Table** - Roteia tráfego para a internet via IGW
- **Security Group** - Firewall com regras de SSH e ICMP
- **Key Pair** - Par de chaves SSH para autenticação
- **EC2 Instance** - Servidor com ferramentas de rede pré-instaladas

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
