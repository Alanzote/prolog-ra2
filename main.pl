% Este arquivo está em UTF-8.
:- encoding(utf8).

% Nomes dos Estados Relacionados aos Respectivos Identificadores.
nome_estado('AC', 'Acre').
nome_estado('AP', 'Amapá').
nome_estado('AM', 'Amazonas').
nome_estado('PA', 'Pará').
nome_estado('RO', 'Rondônia').
nome_estado('RR', 'Roraima').
nome_estado('TO', 'Tocantins').
nome_estado('AL', 'Alagoas').
nome_estado('BA', 'Bahia').
nome_estado('CE', 'Ceará').
nome_estado('MA', 'Maranhão').
nome_estado('PB', 'Paraíba').
nome_estado('PE', 'Pernambuco').
nome_estado('PI', 'Piauí').
nome_estado('RN', 'Rio Grande do Norte').
nome_estado('SE', 'Sergipe').
nome_estado('ES', 'Espirito Santo').
nome_estado('MG', 'Minas Gerais').
nome_estado('RJ', 'Rio de Janeiro').
nome_estado('SP', 'São Paulo').
nome_estado('PR', 'Paraná').
nome_estado('RS', 'Rio Grande do Sul').
nome_estado('SC', 'Santa Catarina').
nome_estado('GO', 'Goiás').
nome_estado('MT', 'Mato Grosso').
nome_estado('MS', 'Mato Grosso do Sul').
nome_estado('DF', 'Distrito Federal').

% Nome das Capitais de Cada Estados Relacionados aos Respectivos Identificadores.
nome_capital('AC', 'Rio Branco').
nome_capital('AP', 'Macapá').
nome_capital('AM', 'Manaus').
nome_capital('PA', 'Belém').
nome_capital('RO', 'Porto Velho').
nome_capital('RR', 'Boa Vista').
nome_capital('TO', 'Palmas').
nome_capital('AL', 'Maceió').
nome_capital('BA', 'Salvador').
nome_capital('CE', 'Fortaleza').
nome_capital('MA', 'São Luis').
nome_capital('PB', 'João Pessoa').
nome_capital('PE', 'Recife').
nome_capital('PI', 'Teresina').
nome_capital('RN', 'Natal').
nome_capital('SE', 'Aracaju').
nome_capital('ES', 'Vitória').
nome_capital('MG', 'Belo Horizonte').
nome_capital('RJ', 'Rio de Janeiro').
nome_capital('SP', 'São Paulo').
nome_capital('PR', 'Curitiba').
nome_capital('RS', 'Porto Alegre').
nome_capital('SC', 'Florianópolis').
nome_capital('GO', 'Goiânia').
nome_capital('MT', 'Cuiabá').
nome_capital('MS', 'Campo Grande').
nome_capital('DF', 'Brasília').

% Os Estados Conectados, incluindo suas distâncias em Km.
node('RS', 'SC', 476).
node('SC', 'PR', 251).
node('PR', 'MS', 780).
node('PR', 'SP', 408).
node('MS', 'SP', 1014).
node('SP', 'RJ', 429).
node('SP', 'MG', 586).
node('MS', 'MG', 1118).
node('RJ', 'MG', 339).
node('RJ', 'ES', 521).
node('ES', 'MG', 524).
node('ES', 'BA', 1202).
node('MG', 'BA', 1372).
node('MG', 'GO', 906).
node('MS', 'GO', 705).
node('MS', 'MT', 559).
node('MT', 'GO', 740).
node('GO', 'TO', 724).
node('GO', 'BA', 1643).
node('BA', 'SE', 356).
node('BA', 'AL', 632).
node('BA', 'PE', 839).
node('BA', 'TO', 1454).
node('BA', 'PI', 994).
node('SE', 'AL', 201).
node('AL', 'PE', 285).
node('PE', 'PB', 120).
node('PE', 'CE', 800).
node('PE', 'PI', 934).
node('PB', 'RN', 185).
node('PB', 'CE', 555).
node('RN', 'CE', 537).
node('CE', 'PI', 634).
node('PI', 'MA', 329).
node('PI', 'TO', 835).
node('TO', 'MA', 964).
node('MT', 'TO', 1029).
node('TO', 'PA', 973).
node('MA', 'PA', 806).
node('PA', 'MT', 2941).
node('MT', 'RO', 1137).
node('MT', 'AM', 1453).
node('RO', 'AC', 544).
node('RO', 'AM', 761).
node('AC', 'AM', 1149).
node('AM', 'RR', 661).
node('AM', 'PA', 1292).
node('RR', 'PA', 6083).
node('PA', 'AP', 329).
node('GO', 'DF', 207).

% Transforma uma lista de estados em uma lista de capitais.
para_capitais([], []). % Caso Base.
para_capitais([E|T], C) :-
	para_capitais(T, CT), % Chamamos Recursivamente.
	nome_capital(E, N), % Conseguimos o nome da capital.
	append([N], CT, C). % Colocar na Lista de Saída.

% Se temos uma rota X, Y, isso quer dizer que temos uma rota Y, X com a mesma distância.
connected(X, Y, Z) :- node(X, Y, Z).
connected(X, Y, Z) :- node(Y, X, Z).

% Encontra o Próximo Nodo.
next_node(A, P, C, D) :-
	connected(A, P, D), % Verifica se está conectado.
	not(member(P, C)). % Temos que ter certeza que no nosso caminho não há esse nodo já.

% Realiza busca em profundidade.
busca_prof(M, M, _, [M], 0) :- !. % Caso base da busca em profundidade.
busca_prof(Inicio, Meta, Visitados, [Inicio|Caminho], Dist) :-
	next_node(Inicio, Prox, Visitados, Dist1), % Encontramos o próximo nodo.
	busca_prof(Prox, Meta, [Prox|Visitados], Caminho, N), % Chamamos o mesmo método recursivamente passando o próximo nodo, a meta, os já visitados...
	Dist is N + Dist1. % Depois de tudo, calculamos a distância.

% Apartir dos nomes das capitais, realiza uma busca em profundidade.
busca_em_profundidade(Comeco, Fim, Caminho, Distancia) :-
	nome_capital(EC, Comeco), % Buscamos o Nome da Capital de Começo.
	nome_capital(EF, Fim), % Buscamos o Nome da Capital de Saída.
	busca_prof(EC, EF, [], CEst, Distancia), % Realizamos a Busca em Profundidade.
	para_capitais(CEst, Caminho). % Transformamos a nossa lista de estados em capitais.

% Realiza a busca pelo nomes de capitais, mas apenas 1 caminho é retornado.
busca_em_profundidade_um_caminho(Comeco, Fim, Caminho, Distancia) :-
	busca_em_profundidade(Comeco, Fim, Caminho, Distancia), !. % Chamamos a busca em profundidade com um CUT, para impedir próximos resultados.

% Transforma B como o 1 elemento da lista A.
consed(A, B, [B|A]).

% Busca em Largura.
busca_larg(M, [[M|C]|_], [M|C]). % Caso base, em que atingimos a meta.
busca_larg(M, [V|RV], C) :-
	V = [I|_], % Colocar I no começo da Lista V.
	findall(X, (connected(X, I, _), not(member(X, V))), L), % Encontrar todos os predicados que o nó não está na lista de visitados e está conectado com o nó anterior.
	maplist(consed(V), L, VE), % Transformar a lista.
	append(RV, VE, VA), % Adicionar a lista de resultado.
	busca_larg(M, VA, C). % Realizar a chamada recursiva de busca em largura.
	
% Apartir dos nomes das capitais, realiza uma busca em largura.
buscar_em_largura(S, D, C) :-
	nome_capital(ES, S), % Transformar em nome do estado.
	nome_capital(ED, D), % Transformar em nome do estado.
	busca_larg(ED, [[ES]], B), % Realizar busca em largura.
	para_capitais(B, C). % Transformar os estados em capitais.
	
% Apartir dos nomes das capitais, realize uma busca em largura, retornando apenas 1 caminho.
buscar_em_largura_um_caminho(S, D, C) :-
	buscar_em_largura(S, D, C), !. % Realizar apenas 1 busca em largura utilizando o CUT depois de conseguir um resultado.
	
