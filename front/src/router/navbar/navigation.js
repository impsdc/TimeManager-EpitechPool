const navigation = [
	{
		name: "Dashboard",
		href: "/dashboard",
		access: [0, 1, 2],
		mobileAvailable: true,
		svg: [
			'<svg\
                xmlns="http://www.w3.org/2000/svg"\
                width="20"\
                height="20"\
                fill="none"\
                viewBox="0 0 24 24"\
                stroke="currentColor"\
			>\
				<path\
					stroke-linecap="round"\
					stroke-linejoin="round"\
					stroke-width="2"\
					d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"\
				/>\
			</svg>',
		],
		svgCode:
			"M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z",
	},
	{
		name: "Dashboard Admin",
		href: "/dashboardAdmin",
		access: [1, 2],
		mobileAvailable: true,
		svg: [
			'<svg\
                xmlns="http://www.w3.org/2000/svg"\
                width="20"\
                height="20"\
                fill="none"\
                viewBox="0 0 24 24"\
                stroke="currentColor"\
			>\
				<path\
					stroke-linecap="round"\
					stroke-linejoin="round"\
					stroke-width="2"\
					d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"\
				/>\
			</svg>',
		],
		svgCode:
			"M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z",
	},
	{
		name: "Settings",
		href: "/settings",
		access: [0, 1, 2],
		mobileAvailable: true,
		svg: [
			'<svg\
                xmlns="http://www.w3.org/2000/svg"\
                width="20"\
                height="20"\
                fill="none"\
                viewBox="0 0 24 24"\
                stroke="currentColor"\
            >\
                <path\
                    stroke-linecap="round"\
                    stroke-linejoin="round"\
                    stroke-width="2"\
                    d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"\
                />\
                <path\
                    stroke-linecap="round"\
                    stroke-linejoin="round"\
                    stroke-width="2"\
                    d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"\
                />\
            </svg>',
		],
		svgCode:
			"M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z",
		svgCode2: "M15 12a3 3 0 11-6 0 3 3 0 016 0z",
	},
	{
		name: "Faq",
		href: "/faq",
		access: [0, 1, 2],
		mobileAvailable: false,
		svg: [
			'<svg\
                xmlns="http://www.w3.org/2000/svg"\
                width="20"\
                height="20"\
                fill="none"\
                viewBox="0 0 24 24"\
                stroke="currentColor"\
            >\
                <path\
                    stroke-linecap="round"\
                    stroke-linejoin="round"\
                    stroke-width="2"\
                    d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"\
                />\
            </svg>',
		],
	},
];

export default navigation;
