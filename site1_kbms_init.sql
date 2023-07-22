set serveroutput on;
set verify off;

drop table Color1 cascade constraints;
drop table Layout1 cascade constraints;
drop table Kit1 cascade constraints;
drop table Switch1 cascade constraints;
drop table Switch3 cascade constraints;
drop table Keyboard1 cascade constraints;
drop table Customer1 cascade constraints;
drop table Order1 cascade constraints;

create table Color1 (
	colid int, name varchar(25), val int,
	primary key (colid)
);

create table Layout1 (
	lid int, name varchar2(25), percent_ int, keys int,
	primary key (lid)
);

create table Kit1 (
	kid int, lid int, name varchar2(25), colid int, manufacturer varchar2(25), quantity int,
	primary key (kid)
	--foreign key (colid) references Color1(colid),
	--foreign key (lid) references Layout1(lid)
);

create table Switch1 (
	sid int, colid int,
	primary key (sid)
	--foreign key (colid) references Color1(colid)
);

create table Switch3 (
	sid int, name varchar2(25), manufacturer varchar2(25), quantity int,
	primary key (sid)
);

create table Keyboard1 (
	kbid int, name varchar2(25), kid int, sid int, price int,
	primary key (kbid)
	--foreign key (kid) references Kit1(kid),
	--foreign key (sid) references Switch1(sid)
);

create table Customer1 (
	cid int, name varchar2(50), email varchar2(25), phone varchar2(20), city int,
	primary key (cid)
);

create table Order1 (
	oid int, quantity int, price int,
	primary key (oid)
	--foreign key (cid) references Customer1(cid),
	--foreign key (kbid) references Keyboard1(kbid)
);

commit;