using iStudyTest.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Http;
using System.Reflection.Metadata;
using NuGet.Protocol;
using iStudyTest.Filters;

namespace iStudyTest.Controllers
{
    public class LoginController : Controller
    {
        private readonly iStudyTestContext _context;
        public LoginController(iStudyTestContext context)
        {
            _context = context;
        }

        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]

        public async Task<IActionResult> Login(Member member)
        {
            var result = await _context.Member.Where(m => m.Email == member.Email && m.Password == _context.ComputeSha256Hash(member.Password)).FirstOrDefaultAsync();

            //如果帳密正確,導入後台頁面
            if (result != null)
            {
                //發給證明,證明他已經登入
                HttpContext.Session.SetString("MemberInfo", result.ToJson());

                return RedirectToAction("Index","Home");
            }
            else //如果帳密不正確,回到登入頁面,並告知帳密錯誤
            {
                ViewData["Message"] = "帳號或密碼錯誤";
            }

            return View(result);
        }
        public IActionResult Logout()
        {
            //5.4.2 在Logout Action中清除Session
            HttpContext.Session.Remove("MemberInfo");//清掉
            return RedirectToAction("Index", "Home");
        }
        public IActionResult Register()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Register(Member member)
        {
            ModelState.Remove("MemberID");  //移除MemberID的驗證，使用DB預存程序產生

            member.Password = _context.ComputeSha256Hash(member.Password); //將密碼雜湊

            if (ModelState.IsValid)
            {
                _context.Add(member);
                await _context.SaveChangesAsync();

                TempData["RegisterMessage"] = "OK";

                return RedirectToAction(nameof(Login));
            }

            return View(member);
        }

        [ServiceFilter(typeof(LoginStatusFilter))]
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var member = await _context.Member.FindAsync(id);
            if (member == null)
            {
                return NotFound();
            }
            return View(member);
        }

        // POST: Members/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, Member member)
        {
            if (id != member.MemberID)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(member);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!MemberExists(member.MemberID))
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
            return View(member);
        }

        public bool MemberEmailCheck(string email)
        {

            var result = _context.Member.Where(m => m.Email == email).FirstOrDefault();
            //Task.Delay(500).Wait();

            return result == null;
        }

        private bool MemberExists(string id)
        {
            return _context.Member.Any(e => e.MemberID == id);
        }

    }
}

