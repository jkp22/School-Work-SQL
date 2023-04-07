-- 5.10 creating tables
-- 5.10a
create table tblCommittee (
CommiteeID				INT				not null Identity(1,1), 
CommiteeName			nvarchar(250)	not null,
MeetingTime				nvarchar(250)	null,
BudgetedExpenditures	Decimal			null,
ExpendituresToDate		Decimal			null,
CommitteeType			nChar(1)		not null ,
Constraint				CommiteePK		primary key (CommiteeID),
constraint		CommiteeSupertypeAK
		Unique(CommiteeName),
constraint		CommiteeTypeCheck
		Check (CommitteeType = 'C' or CommitteeType ='S')
); 
alter table tblCommittee add constraint CommitteeSupertypeAK
	Unique(CommitteeID, CommitteeType)

--5.10b
alter table tblSisterCityCommittee(
SisterCityCommitteeID	Int				not null,
SisterCityID			int				not null,
TopProject				nvarchar(250)	null,
LastVisitToCity			Date			null,
LastVisitFromCity		Date			null,
NextVisitToCity			Date			null,
NextVisitFromCity		Date			null,
CommitteeType			nchar(1)		null DEFAULT 'C' ,
Constraint	SisterCityCommitteeIDPK primary key(SisterCityCommitteeID),
Constraint	SisterCityCommitteeAK1  unique(SisterCityCommitteeID),
Constraint SisterCityCommitteeFK1	Foreign Key(SisterCityCommitteeID)
						REFERENCES tblCommittee(CommitteeID)
						On delete no action
						On update no action,
Constraint	SisterCityCommitteeAk2  unique(SisterCityID),
Constraint  SisterCityCommitteeFK2   Foreign key(SisterCityID)
						REFERENCES tblSisterCity(SisterCityID)
						On delete no action
						On update no action)
alter table tblSisterCityCommittee add constraint		CommiteeTypeCheckC
		Check (CommitteeType = 'C')



--Req 5.10c
Create Table tblSupportCommitee(
SupportCommiteeID		Int				not null,
CityContact				nvarchar(250)	null,
MissionStatement		nvarchar(250)	null,
CommitteeType			nchar(1)		null DEFAULT 'S',
Constraint		SupportCommiteePK		primary key(SupportCommiteeID),
Constraint		SupportCommiteeAK		unique(SupportCommiteeID),
Constraint		SupportCommiteeFK		Foreign Key(SupportCommiteeID)
						REFERENCES tblCommitee(CommiteeID)
						On delete no action
						On update no action
);
Alter table tblSupportCommittee add constraint CommitteeTypeCheckS
		Check (CommitteeType = 'S')

--Req 5.15
Update tblCommitteeIMPORT 
set CommitteeType = 'S'
where CommitteeName = 'Publicity'
or CommitteeName = 'Membership'
or CommitteeName = 'Events'
or CommitteeName = 'Finance'
or CommitteeName = 'Ski to Sea'
or CommitteeName = 'Pac Rim Regatta'

Update tblCommitteeIMPORT 
set CommitteeType = 'C'
where CommitteeName = 'Tateyama'
or CommitteeName = 'Port Stephens'
or CommitteeName = 'Nakhodka'
or CommitteeName = 'Punta Arenas'
or CommitteeName = 'Cheongju'
or CommitteeName = 'Vaasa'

update tblCommitteeIMPORT
set tblCommitteeIMPORT.SisterCityID = tblSisterCity.SisterCityID
from tblCommitteeIMPORT inner join tblSisterCity
on  (tblCommitteeImport.CommitteeName = tblSisterCity.CityName)
WHERE tblCommitteeIMPORT.SisterCityID is null

--req 5.15a
insert into tblCommitee(CommiteeName,MeetingTime,BudgetedExpenditures,ExpendituresToDate,CommitteeType)
select distinct CommitteeName,MonthlyMeetingTime,BudgetedExpenditures,ExpendituresToDate,CommitteeType 
from tblCommitteeIMPORT

--req 5.15b
update tblCommitteeIMPORT
set tblCommitteeIMPORT.CommitteeID = tblCommitee.CommiteeID
from tblCommitteeIMPORT inner join tblCommitee
on  (tblCommitteeImport.CommitteeName = tblCommitee.CommiteeName)
WHERE tblCommitteeIMPORT.CommitteeID is null

--req 5.15C
INSERT INTO tblsupportCommitee(SupportCommiteeID, CityContact,MissionStatement,CommitteeType)
(SELECT DISTINCT CommitteeID, CityGovernmentContact, MissionStatement, CommitteeType 
FROM tblCommitteeIMPORT
WHERE tblCommitteeIMPORT.CommitteeType = 'S')

--req 5.15D
INSERT INTO tblSitsterCityCommitee(SisterCityCommiteeID,
SisterCityID,
TopProject,
LastVisitToCity,
LastVisitFromCity,
NextVisitToCity,
NextVisitFromCity,
CommitteeType)
(SELECT DISTINCT CommitteeID,
SisterCityID,
TopProject,
MostRecentVisitToCity,
MostRecentVisitFromCity,
NextVisitToCity,
NextVisitFromCity,
CommitteeType
FROM tblCommitteeIMPORT
WHERE tblCommitteeIMPORT.CommitteeType = 'C')

--Req 5.20
Create view vueAllDetails_5_20 AS
	select Distinct t.CommiteeName As CommitteeName,
	t.MeetingTime As MeetingTime,
	t.BudgetedExpenditures AS MonthlyExpense,
	t.ExpendituresToDate As ExpensesToDate,
	c.TopProject As TopProject,
	c.LastVisitToCity As MostRecentVisitToCity,
	c.LastVisitFromCity As MostRecentVisitFromCity,
	c.NextVisitToCity As NextVisitToCity,
	c.NextVisitFromCity As NextVisitFromCity,
	s.CityContact As CityContact,
	s.MissionStatement As MissionStatement
	From tblCommitee as t full outer join tblSitsterCityCommitee as c
		on t.CommiteeID = c.SisterCityCommiteeID
			full outer join tblSupportCommitee as s
				on t.CommiteeID = s.SupportCommiteeID;
--req 5.22
Create view vueCommitteeDetails_5_22 As
	select t.CommiteeName As CommitteeName,
	t.MeetingTime As MeetingTime,
	t.BudgetedExpenditures AS MonthlyExpense,
	t.ExpendituresToDate As ExpensesToDate,
	x.Country As Country,
	x.Population as Population,
	x.Description as Description
	From tblCommitee as t inner join tblSisterCity as x
		on t.CommiteeName = x.CityName;

--Req 5.24
Create view vueFinancial_5_24 As
	select t.CommiteeName As CommitteeName,
	t.BudgetedExpenditures AS MonthlyExpense,
	t.ExpendituresToDate As ExpensesToDate,
	(t.BudgetedExpenditures- t.ExpendituresToDate) AS  AmountAvailableToSpend
	From tblCommitee as t

