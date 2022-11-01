:- dynamic questionario/3.

questionario :- carrega('./formulario.bd'),
    format('~n*** Formulario de Triagem ***~n~n'),
    repeat,
    nome(Informacao),
    temperatura(Informacao),
    freqCardiaca(Informacao),
    freqResp(Informacao),
    pressaoSistolica(Informacao),
    saturO2(Informacao),
    dispineia(Informacao),
    idade(Informacao),
    comorbidade(Informacao),
    responde(Informacao),
    salva(questionario,'./questionario.bd').

carrega(Arquivo) :-
    exists_file(Arquivo),
    consult(Arquivo);
    true.

%===== Perguntas ======= %
nome(Informacao) :-
    format('~nQual o nome do paciente? '),
    gets(Informacao).

temperatura(Informacao) :-
    format('~nQual sua temperatura? '),
    gets(Temp),
    asserta(questionario(Informacao,temperatura,Temp)).

freqCardiaca(Informacao) :-
    format('~nQual sua frequencia cardiaca? '),
    gets(FreCard),
    asserta(questionario(Informacao,freqCardiaca,FreCard)).

freqResp(Informacao) :-
    format('~nQual sua frequencia respiratoria? '),
    gets(FreResp),
    asserta(questionario(Informacao,freqResp,FreResp)).

pressaoSistolica(Informacao) :-
    format('~nQual sua pressao arterial sistolica? '),
    gets(PreSis),
    asserta(questionario(Informacao,pressaoSistolica,PreSis)).

saturO2(Informacao) :-
    format('~nQual sua saturacao do oxigenio? (%) : '),
    gets(SaO2),
    asserta(questionario(Informacao,saturO2,SaO2)).

dispineia(Informacao) :-
    format('~nPossui dispneia? (sim ou nao) : '),
    gets(Dispn),
    asserta(questionario(Informacao,dispineia,Dispn)).

idade(Informacao) :-
    format('~nQual eh a sua idade? '),
    gets(Idade),
    asserta(questionario(Informacao,idade,Idade)).

comorbidade(Informacao) :-
    format('~nPossui comorbidades? '),
    format('~nCaso sim, digite a quantidade, se nao digite 0 : '),
    gets(Como),
    asserta(questionario(Informacao,comorbidade,Como)).

salva(Paciente, Dados) :-
    tell(Dados),
    listing(Paciente),
    told.

responde(Informacao) :-
    condicao(Informacao, Char),
    !,
    format('A condicao de ~w eh ~w.~n', [Informacao,Char]).

gets(String) :-
    read_line_to_codes(user_input,Char),
    name(String,Char).

%======  Situacao de Paciente Gravissimo  ======
condicao(Pct, gravissimo) :-
    questionario(Pct,freqResp,Valor), Valor > 30;
    questionario(Pct,pressaoSistolica,Valor), Valor < 90;
    questionario(Pct,saturO2,Valor), Valor < 95;
    questionario(Pct,dispineia,Valor), Valor = "sim".

%======  Situacao de Paciente Grave  ======
condicao(Pct, grave) :-
    questionario(Pct,temperatura,Valor), Valor > 39;
    questionario(Pct,pressaoSistolica,Valor), Valor >= 90, Valor =< 100;
    questionario(Pct,idade,Valor), Valor >= 80;
    questionario(Pct,comorbidade,Valor), Valor >= 2.

%======  Situacao de Paciente Medio  ======
condicao(Pct, medio) :-
    questionario(Pct,temperatura,Valor), (Valor < 35; (Valor > 37, Valor =< 39));
    questionario(Pct,freqCardiaca,Valor), Valor >= 100;
    questionario(Pct,freqResp,Valor), Valor >= 19, Valor =< 30;
    questionario(Pct,idade,Valor), Valor >= 60, Valor =< 79;
    questionario(Pct,comorbidade,Valor), Valor = 1.

%======  Situacao de Paciente Leve  ======
condicao(Pct, leve) :-
    questionario(Pct,temperatura,Valor), Valor >= 35, Valor =< 37;
    questionario(Pct,freqCardiaca,Valor), Valor < 100;
    questionario(Pct,freqResp,Valor), Valor =< 18;
    questionario(Pct,pressaoSistolica,Valor), Valor > 100;
    questionario(Pct,saturO2,Valor), Valor >= 95;
    questionario(Pct,dispineia,Valor), Valor = "nao";
    questionario(Pct,idade,Valor), Valor < 60;
    questionario(Pct,comorbidade,Valor), Valor = 0.
