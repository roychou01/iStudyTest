using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using iStudyTest.Models;

namespace iStudyTest.Controllers
{
    public class InsuranceCompanyController : Controller
    {
        private readonly iStudyTestContext _context;

        public InsuranceCompanyController(iStudyTestContext context)
        {
            _context = context;
        }

        // GET: InsuranceCompany
        public async Task<IActionResult> Index()
        {
            return View(await _context.InsuranceCompany.OrderBy(p => p.CompanyName).ToListAsync());
        }

        // GET: InsuranceCompany/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: InsuranceCompany/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("CompanyID,CompanyName")] InsuranceCompany insuranceCompany)
        {
            var companyid = _context.InsuranceCompany.Find(insuranceCompany.CompanyID);
            var companyname = _context.InsuranceCompany.Find(insuranceCompany.CompanyName);

            if (companyid != null)
            {
                ViewData["ErrorMsg_id"] = "該編號已被使用";
                return View(insuranceCompany);
            }
                 

            if (ModelState.IsValid)
            {
                _context.Add(insuranceCompany);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(insuranceCompany);
        }

        // GET: InsuranceCompany/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var insuranceCompany = await _context.InsuranceCompany.FindAsync(id);
            if (insuranceCompany == null)
            {
                return NotFound();
            }
            return View(insuranceCompany);
        }

        // POST: InsuranceCompany/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("CompanyID,CompanyName")] InsuranceCompany insuranceCompany)
        {
            if (id != insuranceCompany.CompanyID)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(insuranceCompany);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!InsuranceCompanyExists(insuranceCompany.CompanyID))
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
            return View(insuranceCompany);
        }

        // GET: InsCompany/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if ( id == null)
            {
                return NotFound();
            }

            var insuranceCompany = await _context.InsuranceCompany
                .FirstOrDefaultAsync(m => m.CompanyID == id);
            if (insuranceCompany == null)
            {
                return NotFound();
            }
            return View(insuranceCompany);
        }

        // POST: InsCompany/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            var insuranceCompany = await _context.InsuranceCompany.FindAsync(id);
            if (insuranceCompany != null)
            {
                _context.InsuranceCompany.Remove(insuranceCompany);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool InsuranceCompanyExists(string id)
        {
            return _context.InsuranceCompany.Any(e => e.CompanyID == id);
        }
    }
}
