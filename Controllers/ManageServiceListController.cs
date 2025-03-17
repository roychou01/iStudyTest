using iStudyTest.Filters;
using iStudyTest.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.Web.CodeGenerators.Mvc.Templates.Blazor;

namespace iStudyTest.Controllers
{
    
    public class ManageServiceListController : Controller
    {
        private readonly iStudyTestContext _context;

        public ManageServiceListController(iStudyTestContext context)
        {
            _context = context;
        }

        // GET: ServiceLists
        public async Task<IActionResult> Index()
        {
            var iStudyTestContext = _context.ServiceList.Include(s => s.Member).Include(s => s.StateCodeNavigation);
            return View(await iStudyTestContext.ToListAsync());
        }


        // GET: ServiceLists/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var serviceList = await _context.ServiceList
                .Include(s => s.Member)
                .Include(s => s.StateCodeNavigation)
                .FirstOrDefaultAsync(m => m.ServiceNumber == id);
            if (serviceList == null)
            {
                return NotFound();
            }

            return View(serviceList);
        }

        // GET: ServiceLists/Create
        public IActionResult Create()
        {
            
            ViewData["Member"] = new SelectList(_context.Member, "MemberID", "Name");
            ViewData["StateList"] = new SelectList(_context.ServiceState, "StateCode", "State");
            ViewData["Employee"] = new SelectList(_context.Employee, "EmployeeID", "Name");
            return View();
        }

        // POST: ServiceLists/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(ServiceList serviceList)
        {
            serviceList.CreateDate = DateTime.Now;
            serviceList.CurrentBusiness = "";
            ModelState.Remove("ServiceNumber");

            if (ModelState.IsValid)
            {
                _context.Add(serviceList);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["MemberID"] = new SelectList(_context.Member, "MemberID", "MemberID", serviceList.MemberID);
            ViewData["StateCode"] = new SelectList(_context.ServiceState, "StateCode", "StateCode", serviceList.StateCode);
            return View(serviceList);
        }

        // GET: ServiceLists/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var serviceList = await _context.ServiceList.FindAsync(id);
            if (serviceList == null)
            {
                return NotFound();
            }
            ViewData["Member"] = new SelectList(_context.Member, "MemberID", "Name");
            ViewData["StateList"] = new SelectList(_context.ServiceState, "StateCode", "State");
            ViewData["Employee"] = new SelectList(_context.Employee, "EmployeeID", "Name");
            return View(serviceList);
        }

        // POST: ServiceLists/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, ServiceList serviceList)
        {
            if (id != serviceList.ServiceNumber)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(serviceList);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ServiceListExists(serviceList.ServiceNumber))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["MemberID"] = new SelectList(_context.Member, "MemberID", "MemberID", serviceList.MemberID);
            ViewData["StateCode"] = new SelectList(_context.ServiceState, "StateCode", "StateCode", serviceList.StateCode);
            return View(serviceList);
        }

        // GET: ServiceLists/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var serviceList = await _context.ServiceList
                .Include(s => s.Member)
                .Include(s => s.StateCodeNavigation)
                .FirstOrDefaultAsync(m => m.ServiceNumber == id);
            if (serviceList == null)
            {
                return NotFound();
            }

            return View(serviceList);
        }

        // POST: ServiceLists/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            var serviceList = await _context.ServiceList.FindAsync(id);
            if (serviceList != null)
            {
                _context.ServiceList.Remove(serviceList);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ServiceListExists(string id)
        {
            return _context.ServiceList.Any(e => e.ServiceNumber == id);
        }
    }
}
