set serveroutput on;
set verify off;

drop table Color2 cascade constraints;
drop table Layout2 cascade constraints;
drop table Kit2 cascade constraints;
drop table Switch2 cascade constraints;
drop table Keyboard2 cascade constraints;
drop table Customer2 cascade constraints;
drop table Order2 cascade constraints;

create table Color2 (
	colid int, name varchar(25), val int,
	primary key (colid)
);

create table Layout2 (
	lid int, name varchar2(25), percent_ int, keys int,
	primary key (lid)
);

create table Kit2 (
	kid int, lid int, name varchar2(25), colid int, manufacturer varchar2(50), quantity int,
	primary key (kid)
	--foreign key (colid) references Color2(colid),
	--foreign key (lid) references Layout2(lid)
);

create table Switch2 (
	sid int, colid int,
	primary key (sid)
	--foreign key (colid) references Color2(colid)
);

create table Keyboard2 (
	kbid int, name varchar2(25), kid int, sid int, price int,
	primary key (kbid)
	--foreign key (kid) references Kit2(kid),
	--foreign key (sid) references Switch2(sid)
);

create table Customer2 (
	cid int, name varchar2(50), email varchar2(25), phone varchar2(20), city int,
	primary key (cid)
);

create table Order2 (
	oid int, cid int, kbid int, date_ date,
	primary key (oid)
	--foreign key (cid) references Customer2(cid),
	--foreign key (kbid) references Keyboard2(kbid)
);

commit;