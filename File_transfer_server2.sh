# PS: Feche todas as janelas com conexões abertas com o cluster aguia4 para evitar possíveis conflitos de portas abertas.

# 1) Abra um terminal de comandos e copie para seu diretório local o arquivo /home/11217468/.ssh/id_ed25519  que está na shark (ele é sua chave privada e deve ser protegida de forma que outros usuários não tenham acesso) com o seguinte comando que você executa no seu linux local:

scp 11217468@shark.hpc.usp.br:/home/11217468/.ssh/id_ed25519 .

## o ponto “.” no final do comando indica que o arquivo será copiado para seu diretório corrente no seu linux.

## Proteja este arquivo com o seguinte comando:

chmod 700 ./id_ed25519

# 2) Neste mesmo terminal no seu linux abra o túnel digitando sua senha única:

ssh -X -2 -L 8020:aguia4:22 11217468@shark.hpc.usp.br

# 3) Deixe este terminal aberto e, em outro terminal no seu linux, execute o seguinte comando para transferir o diretório /temporario2/11217468/projects para seu servidor:

scp -r -P 8020 -i ./id_ed25519 11217468@localhost:/temporario2/11217468/projects .

## O “-i ./id_ed25519” é a sua “senha” para fazer a conexão com a aguia4 e este comando scp tem que ser digitado no mesmo diretório onde está o arquivo id_ed25519 transferido da shark.hpc.usp.br. A palavra “localhost” deixe assim mesmo e o ponto "." no final indica que os arquivos serão copiados para seu diretório local.
