# Autentica-o-de-Dois-Fatores-em-Flutter-Dart

 Este projeto implementa uma tela de login com autenticação de dois fatores (2FA) para segurança aprimorada. Após o login, os dispositivos são registrados na tabela de "Dispositivos Conectados", evitando 2FA para dispositivos já cadastrados. Inclui um dashboard com funcionalidades CRUD para gerenciar usuários e visualizar dispositivos conectados.

## Configurações

# execute o comando
 ```Bash
    cd projeto_auth
    flutter pub get
```

### 1. Configuração do Banco de Dados

Para que o sistema funcione corretamente, é necessário configurar a conexão com o banco de dados. Recomenda-se o uso do PostgreSQL.

**Passos para configurar a conexão:**

# 1. Acesse `projeto_auth/lib/postgres_auth_service.dart` no seu projeto

# 4. Preencha os campos conforme necessário

- **banco de dados**: Instalar o postgresSql
- **Database**: Nome do banco de dados.
- **User_name**: Nome de usuário para acessar o banco.
- **Password**: Senha do usuário.
- **Server**: Endereço do servidor (use `localhost` se estiver rodando localmente).
- **Port**: Por padrão, utilize `5432`.
**Exemplo de configuração**: No meu exemplo, utilizei `localhost` como servidor, mas você pode especificar outro servidor, se necessário.

# 6. Acesse `projeto_auth/lib/login_controller.dart` no seu projeto

# 4. Preencha os campos Para configuração do email

- **Smpt**: adicione o servidor smpt do seu email exemplo :  Outlook: smtp.office365.com (porta 587), Gmail: smtp.gmail.com (porta 587)
- **Username**: insira seu email
- **password**: insira sua senha
- **porta**: 587 por padrao, mas consulte a documentação do seu servidor Smpt

# Tables a serem criadas no banco Postgres

# Table Login

```Bash
CREATE TABLE login (
    id SERIAL PRIMARY KEY,
    login VARCHAR(50) NOT NULL,
    senha VARCHAR(255) NOT NULL
);
```

# Table dispositivosconnected

```Bash
CREATE TABLE device_details (
    id SERIAL PRIMARY KEY,
    device_type VARCHAR(50) NOT NULL,
    os_info VARCHAR(100),
);
```

# Table tbuserstoken

```Bash
CREATE TABLE tbuserstoken (
    id SERIAL PRIMARY KEY,
    token VARCHAR(6) NOT NULL,
    iduser INTEGER NOT NULL,
    exp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    login BOOLEAN NOT NULL
);
```


## Executando o Projeto
Após configurar a conexão com o banco de dados, você pode executar o sistema de agendamento e começar a utilizá-lo.

## Contribuições
Sinta-se à vontade para contribuir com melhorias ou relatar problemas. Pull requests são bem-vindos!

## Licença
Este projeto está licenciado sob a MIT License. Consulte o arquivo `LICENSE` para mais detalhes.

