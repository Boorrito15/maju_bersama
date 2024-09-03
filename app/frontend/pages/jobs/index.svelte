<script lang="ts">
  import { page } from '@inertiajs/svelte';
  import { Button } from "$lib/components/ui/button";
  import * as Card from "$lib/components/ui/card";
  import * as Avatar from "$lib/components/ui/avatar";
  import { handleApply } from '$lib/jobApplicationUtils';

  export let jobs;
  export let current_user = $page.props.auth.user;

  let appliedJobs = jobs.reduce((acc, job) => {
    acc[job.id] = job.applied_by_current_user;
    return acc;
  }, {});

  function setAppliedJobs(updatedJobs) {
    appliedJobs = updatedJobs;
  }

  async function onApplyClick(job) {
    await handleApply(job, appliedJobs, setAppliedJobs);
  }
</script>


{#if current_user.role === 'candidate'}

  <h1 class="mx-auto my-24 text-5xl text-center">Temukan <span class="text-red-500">Pekerjaan Terbaik</span></h1>
{:else if current_user.role === 'employer'}
  <h1 class="mx-auto my-24 text-5xl text-center">Lowongan <span class="text-red-500">Pekerjaan Anda</span></h1>
{/if}

<div class="grid grid-cols-1 gap-4">
  {#each jobs as job}
    <Card.Root class="w-full max-w-full overflow-hidden rounded-lg shadow-lg">
      <div class="w-full">
        <Card.Header class="flex p-0 pt-6 mt-4">
          <div class="flex px-4 space-x-6">
            <Avatar.Root class="w-24 h-24">
              <Avatar.Image src={job.employer.user.profile_picture} alt="Employer Profile Picture" class="object-cover" />
              <Avatar.Fallback></Avatar.Fallback>
            </Avatar.Root>
            <div class="self-center">
              <Card.Title class="text-xl font-bold">{job.title}</Card.Title>
              <Card.Description class="text-sm">{job.location} . <span class="text-sm">{job.status}</span></Card.Description>
            </div>
          </div>
        </Card.Header>
        <Card.Footer class="flex justify-end pb-4 border-gray-200">
          <Button href={`/jobs/${job.id}`} variant="outline" class="mr-2">Detail Lebih Lanjut</Button>

          {#if current_user.role === 'candidate'}
            <Button
              class={`self-center ${appliedJobs[job.id] ? 'bg-green-600 text-white' : ''}`}
              on:click={() => onApplyClick(job)}
            >
              {appliedJobs[job.id] ? "Applied" : "Apply"}
            </Button>
          {:else if current_user.role === 'employer'}
            <Button href={`/jobs/${job.id}/edit`}>Edit Perkerjaan</Button>
          {/if}
        </Card.Footer>
      </div>
    </Card.Root>
  {/each}
</div>
