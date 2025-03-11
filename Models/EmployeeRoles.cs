using System;
using System.Collections.Generic;

namespace iStudyTest.Models;

public partial class EmployeeRoles
{
    public string RoleCode { get; set; } = null!;

    public string Role { get; set; } = null!;

    public virtual ICollection<Employee> Employee { get; set; } = new List<Employee>();
}
