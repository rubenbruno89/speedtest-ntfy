# speedtest-ntfy

Scripts em lote (`.bat`) para Windows que testam a velocidade da internet e o IP público, salvam o resultado em um arquivo `.txt` e enviam automaticamente para um tópico do [ntfy.sh](https://ntfy.sh), permitindo acompanhar os resultados pelo celular ou navegador.

Os testes são feitos com o [Speedtest CLI](https://www.speedtest.net/pt/apps/cli) da Ookla, e o IP público é obtido via [ifconfig.me](https://ifconfig.me).

## Scripts disponíveis

| Script | Descrição |
|---|---|
| [`speedtest-ntfy.bat`](./speedtest-ntfy.bat) | Executa **um único teste**. Feito para ser chamado pelo Agendador de Tarefas do Windows em intervalos definidos por você. |
| [`speedtest-Loop.bat`](./speedtest-Loop.bat) | Executa os testes **em loop contínuo**, com intervalo configurável direto no script, sem precisar do Agendador de Tarefas. |

Escolha o que melhor se encaixa no seu uso — veja a comparação mais abaixo.

## Pré-requisitos

- Windows com `curl` disponível (já vem nativo a partir do Windows 10)
- [Speedtest CLI](https://www.speedtest.net/pt/apps/cli) instalado e disponível no PATH do sistema (teste digitando `speedtest` no terminal)
- Uma URL de tópico do [ntfy.sh](https://ntfy.sh) para receber as notificações (ex: `ntfy.sh/SeuTopicoAqui`)

## `speedtest-ntfy.bat` — execução única (via Agendador de Tarefas)

Roda um teste, salva o resultado com data e hora no nome do arquivo, e envia para o ntfy.sh. Ideal para deixar o Windows chamá-lo automaticamente em intervalos.

**Como configurar:**

1. Ajuste no script o caminho da pasta onde os resultados serão salvos (ex: `C:\SpeedTest`) e a URL do seu tópico ntfy.sh
2. Crie a pasta configurada, caso ainda não exista
3. Abra o Agendador de Tarefas do Windows (`Win + R` → `taskschd.msc`)
4. Clique em **Criar Tarefa...**
5. Na aba **Geral**: dê um nome à tarefa e marque "Executar mesmo se o usuário não estiver conectado"
6. Na aba **Disparadores**: crie um novo gatilho "Diariamente", com "Repetir a cada" configurado para o intervalo desejado (ex: 1 hora)
7. Na aba **Ações**: aponte para o caminho do `speedtest-ntfy.bat`
8. Salve e informe a senha do usuário quando solicitado

## `speedtest-Loop.bat` — loop contínuo

Roda em uma janela aberta, repetindo o teste automaticamente a cada X minutos (configurável no início do script, na variável `intervalo_minutos`).

**Como usar:**

1. Ajuste a variável `intervalo_minutos` e a URL do seu tópico ntfy.sh no script
2. Dê dois cliques no arquivo para iniciar
3. Deixe a janela aberta — ela ficará rodando os testes automaticamente até ser fechada

## Comparativo

| | `speedtest-ntfy.bat` + Agendador | `speedtest-Loop.bat` |
|---|---|---|
| Sobrevive a reinício do PC | Sim | Não (precisa reabrir) |
| Consome recursos parado | Não | Sim (janela fica aberta) |
| Roda em segundo plano, sem janela | Sim | Não |
| Fácil mudar o horário/intervalo | Sim (interface do Agendador) | Precisa editar o script |
| Configuração inicial | Um pouco mais trabalhosa | Mais simples |

## Resultado

Cada execução gera um arquivo `velocidade_AAAA-MM-DD_HH-MM-SS.txt` contendo:

- IP público no momento do teste
- Data e hora da execução
- Resultado completo do `speedtest` (download, upload, ping, servidor utilizado)

O arquivo é enviado automaticamente para o tópico configurado no ntfy.sh, e pode ser acompanhado em tempo real pelo [app do ntfy](https://ntfy.sh/app) ou pelo navegador.
