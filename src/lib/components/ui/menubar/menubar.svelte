<script lang="ts">
	import { Menubar as MenubarPrimitive } from "bits-ui";
	import { cn } from "$lib/utils.js";

	type $$Props = MenubarPrimitive.Props;

	let className: $$Props["class"] = undefined;
	export { className as class };
</script>

<MenubarPrimitive.Root
	class={cn(
		"flex h-9 items-center space-x-1 rounded-md bg-background p-1 w-full",
		className
	)}
>
	<slot />
</MenubarPrimitive.Root>
