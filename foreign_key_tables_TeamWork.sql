

Create table tblPosition (
PositionID		INT					not null				identity(1,1),
Title			nvarchar(250)		not null,
Constraint		PositionPK			Primary Key(PositionID),
Constraint		PositionAK			Unique(Title)
);

Create table tblAuthorizedCommitteePosition (
PositionID		INT		not null,
CommitteeID		INT		not null,
ApprovedDate	DATE	null,
Constraint		AuthorizedCommitteePositionPK		Primary Key(PositionID, CommitteeID),
Constraint		AuthorizedCommitteePositionFK1		Foreign Key(PositionID)
											References tblPosition(PositionID)
											on delete no action
											on update no action,
Constraint		AuthorizedCommitteePositionFK2		Foreign Key(CommitteeID)
											References tblCommittee(CommitteeID)
											on delete no action
											on update no action
);

Create table tblServiceHistory (
PositionID		INT		not null,
CommitteeID		INT		not null,
PersonID		INT		not null,
ServiceStartDate		Date	not null,
ServiceEndDate			Date	null,
Constraint		ServiceHistoryPK	Primary Key(PositionID, CommitteeID, PersonID, ServiceStartDate),
Constraint		ServiceHistoryFK1	Foreign Key(PositionID, CommitteeID)
								References tblAuthorizedCommitteePosition(PositionID, CommitteeID)
								on delete no action
								on update no action,
Constraint		ServiceHistoryFK3	Foreign Key(PersonID)
								References tblPerson(PersonID)
								on delete no action
								on update no action
);

