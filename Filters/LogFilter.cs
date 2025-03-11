using iStudyTest.Models;
using Microsoft.AspNetCore.Mvc.Filters;
using Newtonsoft.Json;

namespace iStudyTest.Filters
{
    public class LogFilter: IActionFilter
    {
        public void OnActionExecuting(ActionExecutingContext context)
        {
            var MemberJson = context.HttpContext.Session.GetString("MemberInfo");

            if (MemberJson != null)
            {
                var MemberInfo = JsonConvert.DeserializeObject<Member>(MemberJson);
                context.HttpContext.Items["Member"] = MemberInfo;
            }
        }


        public void OnActionExecuted(ActionExecutedContext context)
        {
            // Do something after the action executes.
        }
    }
    
}

