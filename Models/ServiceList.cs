using System;
using System.Collections.Generic;

namespace iStudyTest.Models;

public partial class ServiceList
{
    public string ServiceNumber { get; set; } = null!;

    public DateTime CreateDate { get; set; }

    public string MemberID { get; set; } = null!;

    public string? CurrentBusiness { get; set; }

    public string StateCode { get; set; } = null!;

    public virtual ICollection<Insurance> Insurance { get; set; } = new List<Insurance>();

    public virtual Member? Member { get; set; } 

    public virtual ICollection<ServiceDetail> ServiceDetail { get; set; } = new List<ServiceDetail>();

    public virtual ServiceState? StateCodeNavigation { get; set; } 
}
