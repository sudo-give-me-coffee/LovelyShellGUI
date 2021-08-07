# LovelyGUI
A maneira mais simples e fácil de criar aplicativos GUI para Linux usando shellscript 

A maioria das aplicações utilitárias envolve pegar informações do usuário, processar e exibir ou salvar em disco, e a forma como as informações são captadas tendem a ser basicamente as mesmas porém em layouts diferentes, esse kit trás os principais meios de captação de dados em módulos separados, basicamente tudo que você tem que fazer é pegar os módulos que sua aplicação precisa e pronto, simples assim, você pode focar no processamento dos dados

# Dependencias

 - `sed`
 - `cut`
 - `yad`
 
> Note que `sed` e `cut` geralmente vem pré instalados em praticamente todas as distribuições linux

# Configuração inicial

Requer apenas 2 passos:

1. Na pasta de fontes do seu projeto faça o download do LovelyShellGUI:

```
wget https://raw.githubusercontent.com/sudo-give-me-coffee/LovelyShellGUI/main/src/LovelyShellGUI.sh
```

2. Adicione essa linha no seu projeto:

```
. "$(dirname "$(readlink -f "${0}")")"/LovelyShellGUI.sh
```

E pronto, simples assim, o LovelyShellGUI está configurado, o proximo passo é configurar o seu projeto

# Configurando o seu aplicativo

Todo o LovelyShellGUI é configurado através de variáveis ambientes, as duas primeiras servem para descrever sua aplicação:

```bash
AppTitle="Minha Aplicação"
AppIcon="icone.svg"
```

Ao chamar a função `show` podemos ver o que essas variáveis fazem:

![](img/demo1.png)

`AppTitle` define o título da janela e `AppIcon` define o ícone da janela

> Dica: Procure manter essas variáveis ambientes constantes

# Seu primeiro diálogo

> Embora você possa fazer de forma avulsa, o ideal é seguimentar cada diálogo em uma funçã

Uma vez configurado a base da aplicação, podemos investir nos módulos, vamos dar um titulo com a variável `DialogTitle` e uma descrição com a varíavel `DialogDescription` pro nosso diálogo e vamos exibir usando `show`:

```bash
function digaOi() {
  local DialogTitle="Olá mundo"
  local DialogDescription="Exemplo de diálogo"
  
  show
}
```

Então ao chamar a função `digaOi` temos a seguinte tela:

![](img/demo2.png)

# Trabalhando com entradas do usuário

No exemplo anterior vimos como é simples contruir diálogos, agora vamos ser como é igualmente simples obter a entrada do usuário, para isso nós vamos definir o tipo de dado que queremos obter, para isso definimos a variável `DialogType` com o tipo desejado, por exemplo, podemos definir ela como `input` para pegar uma linha de texto com o nome do usuário:

```bash
function perguntaNome() {
  local DialogTitle="Qual o seu nome?"
  local DialogDescription="Digite seu nome no campo abaixo"
  local DialogType="input"
  
  show
}
```

Então ao chamar a função `perguntaNome` temos a seguinte tela:

![](img/demo3.png)


Note que a função `show` não devolve o que o usuário digitou, o LovelyShellGUI para impedir que o seu código fique poluído armazena os dados na variável global `DIALOG_OUTPUT`, então para obter a entrada do usuário basta pegar o conteúdo dessa variável, veja o mesmo exemplo, agora iniciando outro diálogo com a entrada do usuário:

```bash
function perguntaNome() {
  local DialogTitle="Qual o seu nome?"
  local DialogDescription="Digite seu nome no campo abaixo"
  local DialogType="input"
  
  show
  
  nome=${DIALOG_OUTPUT}
  
  local DialogTitle="Olá ${nome}, tudo bem?"
  local DialogDescription="Viu como é fácil obter a entrada do usuário usando LovelyShellGUI?"
  unset DialogType
  
  show
}
```

Nesse exemplo a variável `nome` recebe a saída da primeira caixa de diálogo (`${DIALOG_OUTPUT}`)

# Detectando o botão "Cancelar" e "Fechar janela"

O LovelyShellGUI foi pensado para tornar a manutenção do código simples e legível, pensando nisso a função `show` foi desenhada para gerir isso, ela retorna `1` quando o usuário clica em  "Cancelar" ou fecha a janela, sendo assim, basta usar o operador `&&` nela para que a próxima ação só seja executada caso o usuário não cancele a operação: 

```bash
function perguntaNome() {
  local DialogTitle="Qual o seu nome?"
  local DialogDescription="Digite seu nome no campo abaixo"
  local DialogType="input"
  
  show && {
    nome=${DIALOG_OUTPUT}
  
    local DialogTitle="Olá ${nome}, tudo bem?"
    local DialogDescription="Viu como é fácil obter a entrada do usuário usando LovelyShellGUI?"
    unset DialogType
  
    show
  }
}
```

Agora a segunda caixa só será exibida se o usuário não fechar a janela ou clicar em "Cancelar


# Trabalhando com diálogos com mais de um campo

Alguns diálogos possuem mais de um campo, para facilitar o processo coloca o valor de cada campo em linhas separadas, assim basta pegar a linha correspondente ao campo, uma das formas de se fazer isoo é usar `variable=$(sed -n Xp <<< "${DIALOG_OUTPUT}")` onde `variable`é o nome da variável e `X` é o número da linha correspondente ao campo, veja o exemplo:

```bash
function perguntaHora() {
  local DialogTitle="Que horas pro alarme?"
  local DialogDescription="Use o formato 24 horas"
  local DialogType="time"
  
  show && {
    horas=$(sed -n 1p <<< "${DIALOG_OUTPUT}")
    minutos=$(sed -n 2p <<< "${DIALOG_OUTPUT}")
      
    local DialogTitle="Você escolheu ${horas} h e ${minutos} min"
    local DialogDescription="Viu como é fácil obter a entrada do usuário usando LovelyShellGUI?"
    unset DialogType
  
    show
  }
}
```

Consulte a documentação de cada diálogo para obter a linha correspondente a cada campo caso se aplica
