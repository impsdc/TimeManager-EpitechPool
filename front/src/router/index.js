import { createRouter, createWebHistory } from "vue-router";
import Login from "@/views/Login.vue";
import Home from "@/views/Home.vue";
import NotFound from "@/views/NotFound.vue";
import Settings from "@/views/Settings.vue";
import Faq from "@/views/Faq.vue";
import User from "@/components/User.vue";
import WorkingTime from "@/components/WorkingTime.vue";
import WorkingTimes from "@/components/WorkingTimes.vue";
import ClockManager from "@/components/ClockManager.vue";
import ChartManager from "@/components/ChartManager.vue";
import Dashboard from "@/components/Layouts/Dashboard";
import DashboardAdmin from "@/components/Layouts/DashboardAdmin";
import DashboardUser from "@/components/Layouts/DashboardUser";

const routes = [
	{
		path: "/:pathMatch(.*)*",
		name: "404",
		component: NotFound,
		meta: {
			title: "404",
			name: "404",
		},
	},
	{
		path: "/",
		redirect: "login",
	},
	{
		path: "/login",
		name: "Login",
		component: Login,
		meta: {
			title: "Login",
			name: "Login",
		},
	},
	{
		path: "/dashboardUser/:userID",
		name: "DashboardUser",
		component: DashboardUser,
		meta: {
			title: "DashboardUser",
			name: "DashboardUser",
		},
	},
	{
		path: "/",
		name: "Home",
		component: Home,
		meta: {
			title: "Home",
			name: "Home",
		},
		children: [
			{
				path: "/dashboard",
				name: "Dashboard",
				component: Dashboard,
				meta: {
					title: "Dashboard",
					name: "Dashboard",
				},
			},
			{
				path: "/dashboardAdmin",
				name: "Dashboard Admin",
				component: DashboardAdmin,
				meta: {
					title: "DashboardAdmin",
					name: "DashboardAdmin",
				},
			},
			{
				path: "/settings",
				name: "Settings",
				component: Settings,
				meta: {
					title: "Settings",
					name: "Settings",
				},
			},
			{
				path: "/faq",
				name: "Faq",
				component: Faq,
				meta: {
					title: "Faq",
					name: "Faq",
				},
			},
			{
				path: "/user",
				name: "User",
				component: User,
				meta: {
					title: "User",
				},
			},
			{
				path: "/workingTime/:userid",
				name: "WorkingTime",
				component: WorkingTime,
				meta: {
					title: "WorkingTime",
				},
			},
			{
				path: "/workingTimes/:userid",
				name: "WorkingTimes",
				component: WorkingTimes,
				meta: {
					title: "WorkingTimes",
				},
			},
			{
				path: "/clockManager/:username",
				name: "ClockManager",
				component: ClockManager,
				meta: {
					title: "ClockManager",
				},
			},
			{
				path: "/chartManager/:userid",
				name: "ChartManager",
				component: ChartManager,
				meta: {
					title: "ChartManager",
				},
			},
		],
	},
];

const router = createRouter({
	history: createWebHistory(),
	routes,
});

router.afterEach((to, from) => {
	// console.log(from, to);
	document.title = to.meta.title;
});

export default router;
