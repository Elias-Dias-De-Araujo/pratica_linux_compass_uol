# Atividade Prática De Linux
## Detalhes
Toda a atividade foi realizada no ambiente da AWS, e toda a parte da prática foi feita utilizando instâncias EC2.

- Duas instâncias EC2 criadas.
- Uma VPC foi criada.
- Uma subnet foi criada.
- Um security group foi criado
- Uma chave de acesso foi criada.
- Dois Elastic IPs foram criados.

## Características da atividade

- Configurar NFS, tanto o lado do servidor quanto o lado do cliente e criar uma pasta compartilhada entre o servidor e o cliente.
- Subir um servidor apache no lado do servidor nfs.
- Criar um script para verificar se o servidor apache está online ou offline e gerar o log para cada uma das situações.
- Direcionar cada log gerado para o diretório compartilhado.

## Configuração do NFS


Na máquina que funciona como **servidor**.

```sh
sudo yum update -y
sudo mkdir /seu_nome
sudo vim /etc/exports
```

Ao abrir o arquivo para edição, digita-se:

```sh
/seu_nome  ip_maquina_cliente(rw,no_root_squash,sync)
```

As opções passadas entre parênteses significam:
- **rw**: Permitir que os cliente possam acessar os arquivos presentes na pasta compartilhada do filesystem no modo leitura e escrita.
- **no_root_squash**: Permitir que os clientes mantenham seus privilégios de usuário root ao acessar a pasta do filesystem.
- **sync** : Funciona como uma forma de sincronizar as mudanças feitas dentros da pasta do filesystem, fazendo com que quaisquer mudanças sejam gravas imediatamente.


Após isso 

```sh
# Iniciar o servidor
sudo systemctl start nfs-server
# Iniciar o servidor junto da máquina
sudo systemctl enable nfs-server 
```

Agora na máquina que funciona como **cliente**.

```sh
sudo mkdir /seu_nome
# Montar o compartilhamento NFS
sudo mount -t nfs ip_servidor:/seu_nome /seu_nome
```

Caso esteja no diretório pessoal, ou qualquer outro fora do raiz, deve-se passar o caminho pra o diretório em questão, por exemplo, caso a pasta tenha sido criada no seu diretório pessoal, o comando fica da seguinte forma: 

```sh
sudo mount -t nfs ip_servidor:/seu_nome  ~/seu_nome
```

## Configuração do servidor apache

Para distribuições que tem debian como base, o nome do pacote seria apache2, todavia, como a AMI escolhida foi o Amazon Linux 2, então ele tem red hat como base, logo o nome do pacote aqui é httpd.

```sh
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
```

## Script para geração de logs do servidor 

```sh
#!/bin/bash

date_hour=$(TZ="America/Fortaleza" date +"%d-%m-%Y %H:%M:%S")
status_server=$(systemctl is-active httpd)

if [ "$status_server" == "active" ]; then
    msg="ONLINE"
else
    msg="OFFLINE"
fi

# Variável guarda o caminho para pasta do filesystem que ficam os logs
archive_name="/sua_pasta/$date_hour.txt"

echo "$date_hour + httpd + $status_server + $msg" > "$archive_name"

```

## Execução automatizada

A execucação automatizada do script foi feita usando o crontab, utilizando:

```sh
crontab -e
*/5 * * * * /bin/bash ../nome_script.sh
```
