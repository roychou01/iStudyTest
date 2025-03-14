using iStudyTest.Filters;
using iStudyTest.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.Web.CodeGenerators.Mvc.Templates.Blazor;

namespace iStudyTest.Controllers
{
    [ServiceFilter(typeof(LoginStatusFilter))]
    public class ServiceListController : Controller
    {
        private readonly iStudyTestContext _context;

        public ServiceListController(iStudyTestContext context)
        {
            _context = context;
        }
        private Member getMemberInfo()
        {
            var member = HttpContext.Items["Member"] as Member;

            return member;
        }

        // GET: ServiceLists
        public async Task<IActionResult> Index()
        {
            //var iStudyTestContext = _context.ServiceList.Include(s => s.Member).Include(s => s.StateCodeNavigation);
            //return View(await iStudyTestContext.ToListAsync());

            var Serlist = _context.ServiceList.Include(o => o.Member).Include(o => o.StateCodeNavigation)
                .Where(o => o.MemberID == getMemberInfo().MemberID)
                .Select(o => new
                {
                    ServiceNumber = o.ServiceNumber,
                    CreateDate = o.CreateDate,
                    MemberName = o.Member.Name,
                    StateName = o.StateCodeNavigation.State,

                });

            return View(await Serlist.ToListAsync());
        }

        // GET: ServiceLists/Create
        public IActionResult Create()
        {
            
            ViewData["MemberID"] = new SelectList(_context.Member, "MemberID", "MemberID");
            ViewData["StateCode"] = new SelectList(_context.ServiceState, "StateCode", "StateCode");
            return View();
        }

        // POST: ServiceLists/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(ServiceList serviceList )
        {
            serviceList.CreateDate = DateTime.Now;
            serviceList.MemberID = (HttpContext.Items["Member"] as Member).MemberID;
            serviceList.StateCode = "01";
            serviceList.CurrentBusiness = "";

            //ModelState.Remove("ServiceNumber");

                _context.Add(serviceList);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));

            //return View(serviceList);

            //ModelState.Clear(); //清除ModelState
            //TryValidateModel(serviceList);  //重新執行Model驗證
        }
        private bool ServiceListExists(string id)
        {
            return _context.ServiceList.Any(e => e.ServiceNumber == id);
        }

    }
}
