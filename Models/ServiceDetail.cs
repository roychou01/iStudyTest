using System;
using System.Collections.Generic;

namespace iStudyTest.Models;

public partial class ServiceDetail
{
    public string ServiceNumber { get; set; } = null!;

    public string EmployeeID { get; set; } = null!;

    public DateTime? ServiceDate { get; set; }

    public virtual Employee? Employee { get; set; } 

    public virtual ServiceList ServiceNumberNavigation { get; set; } = null!;
}
