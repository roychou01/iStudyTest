using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using iStudyTest.Models;
using iStudyTest.ViewModels;
using System.ComponentModel.Design;
using AspNetCoreGeneratedDocument;

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
        public async Task<IActionResult> Index(string companyid = "Chubb017")
        {
            var company = await _context.InsuranceCompany.AsNoTracking().FirstOrDefaultAsync(c => c.CompanyID == companyid);
            if (company == null)
            {
                return NotFound("找不到該保險公司");
            }

            var products= await _context.Product.AsNoTracking().Where(p => p.CompanyID == companyid).ToListAsync();
            var companies = await _context.InsuranceCompany.AsNoTracking().OrderBy(c => c.CompanyName).ToListAsync();

            VMProducts productlist = new VMProducts() {            
                Products = products,
                Companies = companies
            };

            ViewData["CompanyID"] = companyid;
            ViewData["CompanyName"] = company.CompanyName;
            
            return View(productlist);

            //var iStudyTestContext = _context.Product.Include(p => p.Company);
            //return View(await iStudyTestContext.ToListAsync());
        }

        // GET: ManageProducts/Create
        public IActionResult Create(string companyid)
        {
            var model = new Product
            {
                LaunchDate = DateTime.Today, // 設定為今天
            };
            ViewData["Company"] = new SelectList(_context.InsuranceCompany, "CompanyID", "CompanyName");
            ViewData["CompanyID"] = companyid;
            
            
            return View(model);

        }


        // POST: ManageProducts/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Product product, string companyid, IFormFile? newdm)
        {
            product.CompanyID = companyid;
            var productid = _context.Product.Find(product.ProductNumber);
            if (productid != null)
            {
                ViewData["ErrorMsg"] = "該產品編號已被使用";
                ViewData["CompanyID"] = companyid;
                ViewData["Company"] = new SelectList(_context.InsuranceCompany, "CompanyID", "CompanyName");
                return View(product);
            }

            //加上處理上傳照片的功能
            if (newdm != null && newdm.Length != 0)
            {
                if (newdm.ContentType != "image/jpeg" && newdm.ContentType != "image/png")
                {
                    ViewData["Message"] = "請上傳jpg或png格式的檔案!!";
                    return View(product);
                }
                // 取得檔案名稱
                string fileName = product.ProductNumber + ".jpg";

                // 用一個ProductDMPath變數儲存路徑
                string ProductDMPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "ProductPhotos", fileName);//取得目的路徑

                // 把檔案儲存於伺服器上
                using (FileStream stream = new FileStream(ProductDMPath, FileMode.Create))
                {
                    newdm.CopyTo(stream);
                }

                product.DMType = newdm.ContentType;
                product.DM = fileName;
            }

            if (ModelState.IsValid)
            {
                _context.Add(product);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index),new {companyid=product.CompanyID});
            }
            ViewData["Company"] = new SelectList(_context.InsuranceCompany, "CompanyID", "CompanyName");
            ViewData["CompanyID"] = companyid;
            return View(product);

        }

        public async Task<IActionResult> Details(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var product = await _context.Product
                .Include(p => p.Company)
                .FirstOrDefaultAsync(m => m.ProductNumber == id);
            if (product == null)
            {
                return NotFound();
            }

            return View(product);
        }


        // GET: ManageProducts/Edit/5
        public async Task<IActionResult> Edit(string id , string companyid)
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

            ViewData["Company"] = new SelectList(_context.InsuranceCompany, "CompanyID", "CompanyName");
            ViewData["CompanyID"] = companyid;
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
                return RedirectToAction(nameof(Index), new { companyid = product.CompanyID });
            }
            ViewData["CompanyID"] = new SelectList(_context.InsuranceCompany, "CompanyID", "CompanyID", product.CompanyID);
            return View(product);
        }

        // GET: ProductsTest/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var product = await _context.Product
                .Include(p => p.Company)
                .FirstOrDefaultAsync(m => m.ProductNumber == id);
            if (product == null)
            {
                return NotFound();
            }

            return View(product);
        }

        // POST: ProductsTest/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            var product = await _context.Product.FindAsync(id);
            if (product != null)
            {
                _context.Product.Remove(product);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index), new { companyid = product.CompanyID });

        }

        private bool ProductExists(string id)
        {
            return _context.Product.Any(e => e.ProductNumber == id);
        }
    }
}
