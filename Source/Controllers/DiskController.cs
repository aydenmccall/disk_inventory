using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using DiskInventory.Models;


namespace DiskInventory.Controllers
{
    public class DiskController : Controller
    {
        private disk_inventoryamContext context;

        public DiskController(disk_inventoryamContext ctx) => context = ctx;
        public IActionResult Index()
        {
            List<Disk> disks = context.Disks.OrderBy(d => d.DiskName).ThenBy(d => d.ReleaseDate).Include(d => d.DiskType).Include(d => d.Genre)
                .Include(d => d.Status).ToList();
            return View(disks);
        }
        [HttpGet]
        public IActionResult Add()
        {
            ViewBag.Action = "Add";
            ViewBag.Statuses = context.Statuses.OrderBy(g => g.StatusId).ToList();
            ViewBag.Genres = context.Genres.OrderBy(g => g.GenreName).ToList();
            ViewBag.DiskTypes = context.DiskTypes.OrderBy(g => g.TypeName).ToList();
            return View("Edit", new Disk());
        }
        [HttpGet]
        public IActionResult Edit(int id)
        {
            ViewBag.Action = "Edit";
            ViewBag.Statuses = context.Statuses.OrderBy(g => g.StatusId).ToList();
            ViewBag.Genres = context.Genres.OrderBy(g => g.GenreName).ToList();
            ViewBag.DiskTypes = context.DiskTypes.OrderBy(g => g.TypeName).ToList();
            Disk disk = context.Disks.Find(id); // ?? new Disk();
            return View(disk);
        }
        [HttpPost]
        public IActionResult Edit(Disk disk)
        {
            if (ModelState.IsValid)
            {
                if (disk.DiskId == 0)
                    context.Add(disk);
                else
                    context.Update(disk);
                context.SaveChanges();
                return RedirectToAction("Index", "Disk");
            }
            else
            {
                ViewBag.Action = (disk.DiskId == 0) ? "Add" : "Edit";
                ViewBag.Statuses = context.Statuses.OrderBy(g => g.StatusId).ToList();
                ViewBag.Genres = context.Genres.OrderBy(g => g.GenreName).ToList();
                ViewBag.DiskTypes = context.DiskTypes.OrderBy(g => g.TypeName).ToList();
                return View(disk);
            }
            
        }
        [HttpGet]
        public IActionResult Delete(int id)
        {
            Disk disk = context.Disks.Find(id);
            return View(disk);
        }
        [HttpPost]
        public IActionResult Delete(Disk disk)
        {
            context.Disks.Remove(disk);
            context.SaveChanges();
            return RedirectToAction("Index", "Disk");
        }
    }
}
