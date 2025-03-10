using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace iStudyTest.Filters
{
    public class LoginStatusFilter:IActionFilter
    {
        public void OnActionExecuting(ActionExecutingContext context)
        {
            //檢查使用者是否已登入(Session是否有值)
            if (context.HttpContext.Session.GetString("MemberInfo") == null)
            {
                //尚未登入,導向登入頁面
                context.Result = new RedirectToActionResult("Login", "Login", null);
            }

        }
        public void OnActionExecuted(ActionExecutedContext context)
        {

        }

    }
}
