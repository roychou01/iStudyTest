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
    public class ManageProductsController : Controller
    {
        private readonly iStudyTestContext _context;

        public ManageProductsController(iStudyTestContext context)
        {
            _context = context;
        }

        // GET: ManageProducts
        public async Task<IActionResult> Index()
        {
            var iStudyTestContext = _context.Product.Include(p => p.Company);
            return View(await iStudyTestContext.ToListAsync());
        }

        // GET: ManageProducts/Create
        public IActionResult Create()
        {
            ViewData["CompanyID"] = new SelectList(_context.InsuranceCompany, "CompanyID", "CompanyID");
            return View();
        }

        // POST: ManageProducts/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("ProductNumber,ProductName,LaunchDate,DiscontinuedDate,ValidityPeriod,Type,CompanyID,DM,DMType,Feature")] Product product)
        {
            if (ModelState.IsValid)
            {
                _context.Add(product);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["CompanyID"] = new SelectList(_context.InsuranceCompany, "CompanyID", "CompanyID", product.CompanyID);
            return View(product);
        }

        // GET: ManageProducts/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var product = await _context.Product.FindAsync(id);
            if (product == null)
            {
                return NotFound();
            }
            ViewData["CompanyID"] = new SelectList(_context.InsuranceCompany, "CompanyID", "CompanyID", product.CompanyID);
            return View(product);
        }

        // POST: ManageProducts/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("ProductNumber,ProductName,LaunchDate,DiscontinuedDate,ValidityPeriod,Type,CompanyID,DM,DMType,Feature")] Product product)
        {
            if (id != product.ProductNumber)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(product);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ProductExists(product.ProductNumber))
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
            ViewData["CompanyID"] = new SelectList(_context.InsuranceCompany, "CompanyID", "CompanyID", product.CompanyID);
            return View(product);
        }

        private bool ProductExists(string id)
        {
            return _context.Product.Any(e => e.ProductNumber == id);
        }
    }
}
