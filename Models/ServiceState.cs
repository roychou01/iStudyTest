using System;
using System.Collections.Generic;

namespace iStudyTest.Models;

public partial class ServiceState
{
    public string StateCode { get; set; } = null!;

    public string State { get; set; } = null!;

    public virtual ICollection<ServiceList> ServiceList { get; set; } = new List<ServiceList>();
}
