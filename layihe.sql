create table Musteriler(Id number primary key,Ad varchar2(30),Soyad varchar2(30),Unvan varchar2(30),
                        Email varchar2(30),Dogum_tarix date,Phone1 number,Phone2 number);
create table Muqavileler(m_id number unique,Mus_id references Musteriler(Id),Hes_no varchar2(30),
                      Mebleg number,Tarix date,Muddet number,faiz_mebleg number);
insert into Musteriler values(1,'Kamran','Eliyev','Yasamal rayonu','eliyevkamran023@gmail','24.aug.2000',05098766453,0773450802);
insert into Musteriler values(2,'Kemale','Selimova','Buzovna qesebesi','kemaleselim45@gmail','11.jan.2000',null,0778731234);
insert into Musteriler values(3,'Nigar','Babayeva','Ehmedli qesebesi','nigarbabayeva789@gmail','17.mar.1990',0558090236,null);
insert into Musteriler values(4,'Revan','Zahidov','Mastaga qesebesi','zahidovrevan111@gmail','07.jan.1995',0552340908,0709843567);
insert into Musteriler values(5,'Xalid','Velizade','Balaxani qesebesi','xalidveli008@gmail','12.oct.1992',0517098675,0702367002);
insert into Musteriler values(6,'Aysu','Ismayilova','Sabuncu rayonu','aysuismayil34@gmail','01.mar.2001',0506035674,null);
insert into Musteriler values(7,'Gunay','Cavadova','Bineqedi rayonu','cvdgunay77@gmail','20.jul.1999',0515433402,0773495578);
insert into Musteriler values(8,'Rasim','Hesenov','Yasamal rayonu','rasimhesen123@gmail','17.dec.1997',null,0708067354);
insert into Musteriler values(9,'Metin','Memmedli','Ehmedli qesebesi','metinmmdl3@gmail','08.nov.2000',0554300775,0776344512);
insert into Musteriler values(10,'Leman','Abisova','Bineqedi rayonu','abisovalemann82@gmail','28.feb.1994',0501789065,null);

insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(01,1,'11202019440000253253',1500,'27.sep.2022',15);
insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(02,2,'40140019789702043120',1100,'12.mar.2022',10);
insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(03,3,'33882028405855713204',600,'03.jan.2022',20);
insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(04,4,'11202019449331918206',400,'28.aug.2022',25);
insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(05,5,'33898018403101001120',1000,'11.feb.2022',30);
insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(06,6,'33898018401849507204',850,'30.oct.2022',15);
insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(07,7,'33882029789456145204',720,'09.jul.2022',25);
insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(08,8,'43898019781817125204',560,'22.may.2022',20);
insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(09,9,'33881019443152656216',1200,'15.sep.2022',30);
insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(010,10,'33895419449440382304',500,'08.aug.2022',25);
insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(011,1,'33882018409408928204',680,'28.oct.2022',30);
insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(012,7,'33882218409472019304',700,'10.feb.2022',15);
insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(013,4,'33898018401109145120',450,'04.apr.2022',10);
insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(014,8,'33882018401832633204',900,'15.oct.2022',20);
insert into muqavileler(m_id,mus_id,hes_no,mebleg,tarix,muddet) values(015,3,'33898028409238892204',880,'21.sep.2022',10);
create or replace package p_musteri is
function f_faiz(f_id number) return number;
procedure p_muqavile;
end;
create or replace package body p_musteri is
function f_faiz(f_id number)
return number
is l_id muqavileler%rowtype;
begin
  select * into l_id from muqavileler m where m_id=f_id;
   if trunc(sysdate)-l_id.tarix>=l_id.muddet then
    return l_id.faiz_mebleg;
   else return l_id.mebleg;
   end if;
   exception when NO_DATA_FOUND then
     raise_application_error(-20007,'bu muqavile tapilmadi');
   end;
procedure p_muqavile is begin
update muqavileler m set m.faiz_mebleg=case when m.muddet between 10 and 15 then mebleg*1.01
                                    when m.muddet between 16 and 20 then m.mebleg*1.02
                                    when m.muddet between 21 and 25 then m.mebleg*1.03
                                    when m.muddet between 26 and 30 then m.mebleg*1.04
                                    when m.muddet between 31 and 35 then m.mebleg*1.05
                                    when m.muddet<10 then m.mebleg*1.001
                                      else m.mebleg*1.1
                                      end
where  m.Tarix=trunc(sysdate);
end;
end;
select p_musteri.f_faiz(f_id => 24) from dual;
begin
  p_musteri.p_muqavile;
  end;
create or replace  trigger t_musteri
before update on Muqavileler
for each row
  begin
    if to_char(sysdate,'hh24:mi') not between '18:00' and '19:00' then
      raise_application_error(-20005,'update edile bilmez');
      end if;
      end;

      
