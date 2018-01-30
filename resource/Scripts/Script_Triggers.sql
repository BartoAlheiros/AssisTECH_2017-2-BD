use assistech;

#Trigger1. Para atualizar o atributo  "idade" da tabela DEPENDENTE
delimiter |
create trigger update_age
before insert on assistech.dependente
for each row
begin
	#este bloco if corrige o erro que pode ocorrer pela simples subtração do ano_atual - ano_nasc.
    #se o ano 'virou', mas o mês chegou e o dia não é subtraído 1 da data de aniversario calculada
    #pois a pessoa oficialmente ainda não fez aniversário.
    if  ( MONTH(curdate()) < MONTH(new.Data_nascimento) or MONTH(curdate()) >= MONTH(new.Data_nascimento) ) and DAY(curdate()) < DAY(New.Data_nascimento) then
		set new.Idade = ((YEAR(curdate())) - YEAR(new.Data_nascimento))-1;
        elseif MONTH(curdate()) >= MONTH(new.Data_nascimento) and DAY(curdate()) >= DAY(new.Data_nascimento) then
			set new.Idade = (YEAR(curdate())) - YEAR(new.Data_nascimento);
    end if;
end|

drop trigger upd_num_func_del;

#Trigger2.1  Para atualizar   o atributo "Num.Funcionarios" de UNIDADE DE SUPORTE ao Inserir um Funcionário.
delimiter |
create trigger upd_num_func_ins
after insert on assistech.funcionario
for each row
begin
	SET @num_func:=(select Nro_funcionarios from assistech.unidade_de_suporte where Cod=new.CodigoUnidadeDeSuporte);
    UPDATE assistech.unidade_de_suporte SET Nro_funcionarios = @num_func + 1 WHERE  Cod=new.CodigoUnidadeDeSuporte;
end |

#Trigger2.2  Para atualizar   o atributo "Num.Funcionarios" de UNIDADE DE SUPORTE ao Remover um Funcionário.
delimiter |
create trigger upd_num_func_del
after delete on assistech.funcionario
for each row
begin
	SET @num_func:=(select Nro_funcionarios from assistech.unidade_de_suporte where Cod=old.CodigoUnidadeDeSuporte);
    UPDATE assistech.unidade_de_suporte SET Nro_funcionarios = @num_func - 1 WHERE  Cod=old.CodigoUnidadeDeSuporte;
end |

#Trigger3.  Para  gerar o valor do atributo "dt_devida" de ORDEM DE SERVICO
delimiter |
create trigger set_dta_devida
before insert on assistech.ordem_servico
for each row
begin

     SET @last_month_day:=DAY(LAST_DAY( curdate() ));
     SET @delivery_year:=YEAR(new.Dt_criacao);
     SET @delivery_month:=MONTH(new.Dt_criacao);
	 SET @delivery_day:=DAY(new.Dt_criacao);
 
     #este if verifica se o ano eh bissexto
     #o if mais interno verifica se o mes eh fevereiro(2)
     if (YEAR(new.Dt_criacao) %4 = 0) AND (YEAR(new.Dt_criacao) % 100 != 0) OR (YEAR(new.Dt_criacao) % 400 = 0)  then
		if MONTH(new.Dt_criacao)=02 AND (new.Prazo_em_dias + day(new.Dt_criacao)) > 29 then
			set @diferenca:=abs(29 - ( new.Prazo_em_dias + day(new.Dt_criacao) ) );
            set new.Dt_devida=CONCAT(YEAR(new.Dt_criacao), '-','03', '-',@diferenca);
        end if;	
	 end if;
     
     
		
end |

drop trigger set_dta_devida;

#select abs(7);
#SELECT DAY(LAST_DAY( curdate() )) as DIAS_MES;

#drop trigger upd_num_funcionarios; #show triggers in assistech;