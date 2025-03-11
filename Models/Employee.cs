using System;
using System.Collections.Generic;

namespace iStudyTest.Models;

public partial class Employee
{
    public string EmployeeID { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string Gender { get; set; } = null!;

    public DateOnly Birthday { get; set; }

    public string Address { get; set; } = null!;

    public string? Phone { get; set; }

    public string PersonalID { get; set; } = null!;

    public DateOnly? HireDate { get; set; }

    public string? JobTitle { get; set; }

    public string? Experience { get; set; }

    public string? EmployeePhoto { get; set; }

    public string RoleCode { get; set; } = null!;

    public string Password { get; set; } = null!;

    public DateOnly? DueDate { get; set; }

    public virtual EmployeeRoles? RoleCodeNavigation { get; set; } 

    public virtual ICollection<ServiceDetail> ServiceDetail { get; set; } = new List<ServiceDetail>();
}
